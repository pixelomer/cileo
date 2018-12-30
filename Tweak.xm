#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Extensions/UIAlertController+PresentAlertWithTitle.h"
#import "libu0sileo/u0sileo.h"
#if DEBUG
#import <AVFoundation/AVFoundation.h>
#define NSLog(args...) NSLog(@"[u0sileo] "args)
#else
#define NSLog(...); /* */
#endif
#define rootViewController [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define mainBundle [NSBundle mainBundle]
#define bundleID [mainBundle bundleIdentifier]
#define GetPropertyFromObject(obj, propertyName) [obj performSelector:@selector(propertyName)]

// Input: (self, author, @"Steve Jobs")
// Result: [self performSelector:@selector(setAuthor:) withObject:@"SteveJobs"]
#define SetPropertyForObject(obj, propertyName, newValue) [obj performSelector:NSSelectorFromString( \
	[NSString stringWithFormat:@"set%@%@:", \
		[[NSString stringWithFormat:@"%c", (char)[@(#propertyName) characterAtIndex:0]] uppercaseString], \
		[@(#propertyName) substringFromIndex:1] \
	] \
) withObject:newValue]

static id downloadManager;

%hook PackageQueueButton

- (void)buttonTapped:(UIButton * /* PackageQueueButton */)button {
	id package = [self performSelector:@selector(package)];
	id repo = GetPropertyFromObject(package, sourceRepo);
	NSString *repoURL = nil;
	if (repo) repoURL = GetPropertyFromObject(repo, repoURL);
	if (package) {
		if ((BOOL)GetPropertyFromObject(package, commercial)) {
			[UIAlertController presentAlertWithTitle:@"Commercial Package" message:@"PixelOmer's Sileo backend doesn't support paid packages yet." buttonText:@"OK"];
		}
		else {
			NSLog(@"Package information\nName: %@\nPackage: %@\nRepository: %@", GetPropertyFromObject(package, name), GetPropertyFromObject(package, package), repoURL);
			if ([button.titleLabel.text isEqualToString:@"GET"]) {
				[UIAlertController presentAlertWithTitle:@"Installation" message:[NSString stringWithFormat:@"Are you sure you want to install %@?", GetPropertyFromObject(package, name)] buttons:@[
					[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(id v1){
						id progressVC = [[%c(SourcesErrorsViewController) alloc] init];
						[(UIViewController*)progressVC setModalPresentationStyle:UIModalPresentationFullScreen];
						[rootViewController presentViewController:progressVC animated:YES completion:nil];
						Process *proc = [[Process alloc] initWithBinaryAtPath:@"/usr/bin/apt-get"
    						withArguments:[@"-qq --allow-unauthenticated -y install " stringByAppendingString:GetPropertyFromObject(package, package)]
	    					withEUID:0];
						UITextView *outputView = GetPropertyFromObject(progressVC, errorOutputText);
						proc.outputHandler = ^void(NSTask *task, NSString *newLine, BOOL isError) {
							NSLog(@"%@", newLine);
							dispatch_sync(dispatch_get_main_queue(), ^{
								@autoreleasepool {
									NSMutableAttributedString *string = [outputView.attributedText mutableCopy];
									NSAttributedString *newString = [[NSAttributedString alloc] initWithString:newLine attributes:@{
										NSForegroundColorAttributeName : isError ? [UIColor redColor] : [UIColor whiteColor],
										NSFontAttributeName : [UIFont fontWithName:@"Menlo-Regular" size:12]
									}];
									[string appendAttributedString:newString];
									outputView.attributedText = [string copy];
								}
							});
						};
						proc.terminationHandler = ^void(NSTask *task, int exitCode) {
							[downloadManager performSelector:@selector(reloadData)];
						};
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
							[proc launch];
						});
					}],
					[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(id v1){}]
				] target:rootViewController alertStyle:UIAlertControllerStyleActionSheet];
			}
			else if ([button.titleLabel.text isEqualToString:@"MODIFY"]) {

			}
		}
	}
}

%end

%hook PackageQueueButton

- (void)setTitle:(id)v1 forState:(unsigned long long)v2 {
	NSLog(@"-[PackageButton setTitle:@\"%@\" forState:%llu]", v1, v2);
	%orig;
}

%end

%hook RepoManager

- (void)updateWithCompletion:(void (^)(void))v1 forceUpdate:(bool)v2 forceReload:(bool)v3 {
	%orig;
}

%end

%ctor {
	// DEBUG KILLSWITCH: The tweak is disabled when it's built for debugging and the device volume is 0%
	#if DEBUG
	if ([[AVAudioSession sharedInstance] outputVolume] != 0.) {
	#endif
		downloadManager = [[[%c(DownloadManager) alloc] init] retain];
		%init;
	#if DEBUG
	}
	#endif
}