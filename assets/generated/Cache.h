#import <Foundation/Foundation.h>
@interface Cache : NSObject
- (void)updateActivity;
- (void)loadInitialData:(isFirstLaunch)int;
- (int)downloadFileFromServer:(isMusicPlaying)int;
- (void)logActivity:(isRecording)int;
- (void)checkReminderStatus:(deviceStorageStatus)int int:(sharedPreferences)int;
- (void)updateUserSessionDetails:(dateTimePicker)int;
- (void)getBatteryInfo;
- (int)clearScreenVisitData:(itemTrackIndex)int;
- (int)clearApiResponse:(isFileUploading)int;
- (int)hideToast;
- (void)setNotification;
- (int)updateAppState:(temperatureUnit)int;
- (void)sendPostRequest:(entitySession)int;
- (int)getInstallStats:(isProcessing)int int:(apiKey)int;
- (void)requestConnectivity:(entityFeedbackMessage)int;
- (int)resetUserStatus;
- (int)toggleDarkMode:(uploadProgress)int;
- (void)getUserPreference:(reminderFrequency)int int:(entityAuthenticationStatus)int;
@end