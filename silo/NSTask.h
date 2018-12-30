@interface NSTask : NSObject

@property (copy) NSArray *arguments;
@property (copy) NSURL *currentDirectoryURL;
@property (copy) NSDictionary *environment;
@property (copy) NSURL *executableURL;
@property (readonly) int processIdentifier;
@property long long qualityOfService;
@property (getter=isRunning, readonly) bool running;
@property (retain) id standardError;
@property (retain) id standardInput;
@property (retain) id standardOutput;
@property (copy) id /* block */ terminationHandler;
@property (readonly) long long terminationReason;
@property (readonly) int terminationStatus;

+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithExecutableURL:(id)arg1 arguments:(id)arg2 error:(out id*)arg3 terminationHandler:(id /* block */)arg4;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;

- (id)arguments;
- (id)currentDirectoryPath;
- (id)currentDirectoryURL;
- (id)environment;
- (id)executableURL;
- (void)waitUntilExit;
- (id)init;
- (void)interrupt;
- (bool)isRunning;
- (void)launch;
- (bool)launchAndReturnError:(id*)arg1;
- (id)launchPath;
- (int)processIdentifier;
- (long long)qualityOfService;
- (bool)resume;
- (void)setCurrentDirectoryPath:(id)arg1;
- (void)setLaunchPath:(id)arg1;
- (void)setQualityOfService:(long long)arg1;
- (id)standardError;
- (id)standardInput;
- (id)standardOutput;
- (bool)suspend;
- (long long)suspendCount;
- (void)terminate;
- (id /* block */)terminationHandler;
- (long long)terminationReason;
- (int)terminationStatus;

@end