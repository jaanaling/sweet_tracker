#import <Foundation/Foundation.h>
@interface Enhancer : NSObject
- (void)refreshContent;
- (void)changeLanguage:(isVoiceCommandEnabled)int;
- (void)getUserStatusReport:(appState)int;
- (int)sendUserMessagesInteractionData:(timeZoneOffset)int int:(surveyCompletionFailureMessageTime)int;
- (int)saveSettings;
- (void)parseJsonError:(appInMemoryUsage)int int:(surveyAnswerCompletionMessageText)int;
- (int)setInstallDetails:(surveySubmissionDateTime)int int:(surveyStartTime)int;
- (int)getTheme:(itemPlaybackPosition)int;
- (int)getMessageData:(appDownloadStatus)int;
- (void)getUserNotificationData;
- (void)clearUserNotificationData:(surveyAnswerCompletionMessageProgress)int int:(surveyCompletionSuccessStatus)int;
- (void)pauseApp;
- (int)trackLocation;
- (int)setAppLanguage;
@end