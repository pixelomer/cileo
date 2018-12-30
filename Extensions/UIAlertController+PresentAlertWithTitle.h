@interface UIAlertController(PresentAlertWithTitle)
+ (void)presentAlertWithTitle:(NSString* _Nonnull)title message:(NSString* _Nonnull)message buttonText:(NSString* _Nonnull)buttonText target:(id _Nonnull)target;
+ (void)presentAlertWithTitle:(NSString* _Nonnull)title message:(NSString* _Nonnull)message buttonText:(NSString* _Nonnull)buttonText;
+ (void)presentAlertWithTitle:(NSString* _Nonnull)title
    message:(NSString* _Nonnull)message
    buttons:(NSArray<UIAlertAction*>* _Nullable)buttons
    target:(id _Nonnull)target
    alertStyle:(UIAlertControllerStyle)style;
@end