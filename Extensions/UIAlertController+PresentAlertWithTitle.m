#import "UIAlertController+PresentAlertWithTitle.h"

@implementation UIAlertController(PresentAlertWithTitle)

+ (void)presentAlertWithTitle:(NSString* _Nonnull)title message:(NSString* _Nonnull)message buttonText:(NSString* _Nonnull)buttonText {
    [UIAlertController presentAlertWithTitle:title
        message:message
        buttonText:buttonText
        target:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
    ];
}

+ (void)presentAlertWithTitle:(NSString* _Nonnull)title message:(NSString* _Nonnull)message buttonText:(NSString* _Nonnull)buttonText target:(id _Nonnull)target {
    [UIAlertController presentAlertWithTitle:title message:message buttons:@[
        [UIAlertAction actionWithTitle:buttonText style:UIAlertActionStyleDefault handler:^(id v1){}]
    ] target:target alertStyle:UIAlertControllerStyleAlert];
}

+ (void)presentAlertWithTitle:(NSString* _Nonnull)title
    message:(NSString* _Nonnull)message
    buttons:(NSArray<UIAlertAction*>* _Nullable)buttons
    target:(id _Nonnull)target
    alertStyle:(UIAlertControllerStyle)style
{
    NSArray *actions = buttons;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    if (!actions || [actions count] <= 0) actions = @[
        [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(id v1){}]
    ];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    [target presentViewController:alert animated:YES completion:nil];
}

@end