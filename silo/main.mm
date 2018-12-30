#import <CoreFoundation/CoreFoundation.h>
#import "NSTask.h"

void outputHandler(NSTask *task, NSString *newData, BOOL isError) {
	if (isError) fprintf(stderr, "%s", [newData UTF8String]);
	else fprintf(stdout, "%s", [newData UTF8String]);
}

int main(int argc, char **argv, char **envp) {
	setuid(0);
	if (argc >= 3) {
		uid_t uid = [[NSString alloc] initWithUTF8String:argv[1]].intValue;
		setuid(uid);
		@autoreleasepool {
			NSString *command = [[NSString alloc] initWithUTF8String:argv[2]];
			NSArray *task_args = @[
				@"-c", command
			];
			NSTask *task = [[NSTask alloc] init];
			NSPipe *errPipe = [[NSPipe alloc] init];
			NSPipe *standardPipe = [[NSPipe alloc] init];
			NSString *binaryPath = @"/bin/bash";
			[task setLaunchPath:binaryPath];
			[task setArguments:task_args];
			[task setStandardError:errPipe];
			[task setStandardOutput:standardPipe];
			errPipe.fileHandleForReading.readabilityHandler = ^void(NSFileHandle *handle) {
				NSData *newData = handle.availableData;
				if (newData) {
					NSString *newLine = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
					if (newLine && newLine.length > 0) outputHandler(task, newLine, YES);
				}
			};
			standardPipe.fileHandleForReading.readabilityHandler = ^void(NSFileHandle *handle) {
				NSData *newData = handle.availableData;
				if (newData) {
					NSString *newLine = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
					if (newLine && newLine.length > 0) outputHandler(task, newLine, NO);
				}
			};
			[task launch];
			NSLog(@"==== BEGIN ACTUAL OUTPUT ====");
			[task waitUntilExit];
			exit(task.terminationStatus);
		}
	}
}