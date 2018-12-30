#import "../silo/NSTask.h"
#import <Foundation/Foundation.h>

@interface Process : NSObject {}
@property (nonatomic, retain, nonnull) NSString *binaryPath;
@property (nonatomic, retain, nonnull) NSString *arguments;
@property (nonatomic) uid_t EUID;
/* Output Handler
 * - The block must take 3 arguments. The first argument will contain the NSTask object
 * for the current process. The second argument contains the new output. The third argument
 * will be YES if the new output is an error.
 */
@property (nonatomic, copy, nullable) void (^outputHandler)(NSTask* _Nonnull, NSString* _Nonnull, BOOL);
@property (nonatomic, copy, nullable) void (^terminationHandler)(NSTask* _Nonnull, int exitCode);
@property (nonatomic, nullable) int *exitCode;
- (_Nullable instancetype)initWithBinaryAtPath:(NSString* _Nonnull)path
    withArguments:(NSString * _Nonnull)args
    withEUID:(uid_t)euid;
- (void)launch;
@end