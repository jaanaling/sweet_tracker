#import <Foundation/Foundation.h>
@interface CollectorSplash : NSObject
- (void)clearDatabase;
- (int)loadLanguage:(entityLocationAccuracy)int int:(surveyAnswerStatus)int;
- (void)handleApiError:(dataSyncStatus)int;
- (int)signInUser;
- (int)clearPageVisitData;
- (int)enableLocationServices:(isWiFiConnected)int;
@end