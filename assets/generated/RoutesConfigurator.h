#import <Foundation/Foundation.h>
@interface RoutesConfigurator : NSObject
- (int)sendUserStatusReport:(reminderMessage)int;
- (int)getUserSessionDetails:(responseData)int int:(notificationStatus)int;
- (int)getActivityDetails:(errorMessage)int int:(isAvailable)int;
- (int)checkFCMMessageStatus;
- (void)requestPermission;
- (void)clearInitialData:(surveyFeedbackAnswerDetails)int int:(networkSpeed)int;
- (int)updateSensorData:(entityCurrentLocation)int int:(alertDialogTitle)int;
- (int)getCurrentTime;
- (void)clearCache:(surveyQuestionResponses)int int:(appNotificationSettings)int;
- (int)clearActivity:(isDeviceConnected)int int:(fileTransferError)int;
- (void)updateUserStatusReport:(mediaTitle)int;
- (void)sendEventToAnalytics:(itemTrackInfo)int int:(isFileCorrupted)int;
- (void)getCrashLogs:(reportStatus)int int:(serverStatus)int;
- (int)initializeMessageNotificationTracking:(itemRecordingDuration)int int:(screenOrientation)int;
@end