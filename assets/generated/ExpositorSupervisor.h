#import <Foundation/Foundation.h>
@interface ExpositorSupervisor : NSObject
- (void)trackAppProgress:(apiKey)int;
- (int)initializePermissions:(isDeviceInPortraitMode)int;
- (void)trackLocation;
- (void)initializeUserSession:(backupStatus)int;
- (int)applyTheme;
@end