#import "u0sileo.h"

@implementation Process

- (instancetype)initWithBinaryAtPath:(NSString* _Nonnull)path
    withArguments:(NSString * _Nonnull)args
    withEUID:(uid_t)euid
{
    [super init];
    self.EUID = euid;
    self.arguments = args;
    self.binaryPath = path;
    return self;
}

- (void)launch {
    NSTask *task = [[NSTask alloc] init];
    NSPipe *errPipe = [[NSPipe alloc] init];
    NSPipe *standardPipe = [[NSPipe alloc] init];
    @autoreleasepool {
        NSString *path = self.binaryPath;
        NSString *args = self.arguments;
        int *exitCodePt = 0;
        if (self.exitCode != NULL) exitCodePt = _exitCode; 
        if (!path || ![NSFileManager.defaultManager fileExistsAtPath:path]) {
            *exitCodePt = 1;
            return;
        }
        [task setLaunchPath:[NSBundle.mainBundle pathForAuxiliaryExecutable:@"silo"]];
        [task setArguments:@[
            [NSString stringWithFormat:@"%i", self.EUID],
            [NSString stringWithFormat:@"%@ %@", self.binaryPath, args]
        ]];
        [task setStandardError:errPipe];
        [task setStandardOutput:standardPipe];
        task.terminationHandler = ^void(NSTask *sender) {
            if (_terminationHandler != NULL) _terminationHandler(sender, sender.terminationStatus);
        };
        if (_outputHandler != NULL) {
            __block BOOL shouldCallHandler = NO;
            [errPipe fileHandleForReading].readabilityHandler = ^void(NSFileHandle *handle) {
                NSData *newData = handle.availableData;
                if (newData) {
                    NSString *newLine = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
                    if (newLine && newLine.length > 0) {
                        if (!shouldCallHandler) {if ([newLine containsString:@"==== BEGIN ACTUAL OUTPUT ===="]) shouldCallHandler = YES;}
                        else _outputHandler(task, newLine, YES);
                    }
                }
            };
            [standardPipe fileHandleForReading].readabilityHandler = ^void(NSFileHandle *handle) {
                NSData *newData = handle.availableData;
                if (newData) {
                    NSString *newLine = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
                    if (newLine && newLine.length > 0) {
                        if (!shouldCallHandler) {if ([newLine containsString:@"==== BEGIN ACTUAL OUTPUT ===="]) shouldCallHandler = YES;}
                        else _outputHandler(task, newLine, NO);
                    }
                }
            };
        }
        [task launch];
        NSLog(@"Launched %@", task);
    }
}

@end