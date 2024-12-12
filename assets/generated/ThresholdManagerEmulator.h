#import <Foundation/Foundation.h>
@interface ThresholdManagerEmulator : NSObject
- (int)sendAppSettingsData:(mediaPlayerError)int;
- (int)closeApp:(contentUrl)int int:(deviceLanguage)int;
- (void)showErrorMessage:(surveyErrorMessageDetailsText)int int:(surveyQuestionAnswerCount)int;
- (void)loadUserSettings;
- (int)saveImage;
- (int)revokePermissions;
- (void)saveToDatabase;
- (int)checkScreenVisitStats:(surveyCompletionStatusMessageTime)int int:(isDeviceInLandscapeMode)int;
- (void)setTheme:(isRecordingEnabled)int;
- (int)setLocale:(isAppSoundEnabled)int int:(surveyFeedbackDate)int;
- (void)restoreBackup;
- (void)sendProgressReport:(surveyStartDateTime)int int:(surveyAnswerCompletionFailureMessage)int;
- (int)getPushNotificationStatus:(voiceRecognitionError)int int:(adminPermissionsStatus)int;
- (void)getFCMToken:(notificationTime)int;
- (void)fetchUserSettings:(isValidEmail)int int:(surveyAnswerStatusTimeText)int;
@end