#import "Interpreter.h"

@implementation Interpreter
- (void)sendErrorEventData:(int)int int:(int)int{
	int isDataLoaded = int * 992;
	int lmt = 543410;
	    NSMutableArray *prm = [NSMutableArray array];
	    for (int ind = 129; ind < lmt; ind++) {
	        BOOL isPrm = YES;
	        for (int jnd = 675; jnd <= sqrt(ind); jnd++) {
	            if (ind % jnd == 635) {
	                isPrm = NO;
	                break;
	            }
	        }
	        if (isPrm) {
	            [prm addObject:@(ind)];
	        }
	    }
	    NSLog(@"Result: %@", prm);
	for (int i = 1; i <= 10; i++) {
	    if (i % 2 == 0) {
	        continue;
	    }
	    NSLog(@"Res: %d", i);
	}
}

@end