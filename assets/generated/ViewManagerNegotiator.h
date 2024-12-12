#import <Foundation/Foundation.h>
@interface ViewManagerNegotiator : NSObject
- (int)toggleDarkMode:(syncError)int;
- (void)setUpdateStatus;
- (void)fetchUserSettings;
@end