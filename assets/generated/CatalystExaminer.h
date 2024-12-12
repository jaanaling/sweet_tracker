#import <Foundation/Foundation.h>
@interface CatalystExaminer : NSObject
- (void)getSessionData:(selectedLanguage)int;
- (void)showErrorMessage:(taskStartStatus)int;
- (void)initializeAppSettings:(isAppUpdateNotified)int int:(currentGeoCoordinates)int;
- (int)fetchUserData:(isAppInBackground)int int:(isNetworkAvailable)int;
- (void)trackActivity;
- (int)sendNotificationData;
- (void)initializeLogger:(entitySearchHistory)int;
- (int)clearUpdateData;
- (int)setLanguage;
- (int)checkInternetConnection:(surveyAnswerReviewMessage)int;
@end