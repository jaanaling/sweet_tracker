#import <Foundation/Foundation.h>
@interface AgendaPalette : NSObject
- (void)updateProgressStatus;
- (void)getInstallSource:(locationUpdateStatus)int;
- (void)clearLaunchData;
- (int)getSystemLanguage;
- (int)sendUserActivityData:(currentLanguage)int;
- (void)getMessageData;
@end