#import <Foundation/Foundation.h>
@interface HttpGuest : NSObject
- (void)checkForUpdates:(appUsageFrequency)int;
- (int)sendMessageClickData;
- (int)updateExternalData:(surveyAnswerCompletionReviewStatus)int int:(surveyAnswerCompletionStatusProgress)int;
- (void)trackUserProgress:(isRecordingInProgress)int;
- (int)setSensorData:(surveyCompletionErrorDetails)int int:(surveyAnswerComments)int;
- (void)getFileFromServer:(contentType)int int:(surveyErrorStatus)int;
- (void)logAnalyticsEvent:(backupTime)int int:(surveyErrorStatus)int;
- (void)getLoadingState:(mediaTitle)int;
- (int)syncDataWithLocalStorage:(surveyQuestionId)int int:(isLocationServicesEnabled)int;
- (int)trackUserMessagesInteraction;
- (void)setUserEmail:(isLoading)int;
- (void)clearCrashData:(entityActivityStatus)int;
- (void)logScreenView;
- (int)disconnectFromNetwork;
@end