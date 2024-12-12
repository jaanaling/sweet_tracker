#import <Foundation/Foundation.h>
@interface Local : NSObject
- (void)getUserEmail;
- (void)trackMessageEvents:(surveyReviewCount)int;
- (void)trackScreenVisit:(deviceId)int int:(isMuted)int;
@end