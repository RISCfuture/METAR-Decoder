#import "METAR+Remarks.h"

@implementation METAR (Remarks)

- (NSArray *) decodedRemarks {
    if (!self.remarks) return nil;

    NSMutableString *consumableRemarks = [NSMutableString stringWithString:self.remarks];
    NSMutableArray *decodedRemarks = [NSMutableArray new];
    
    Remark *nextRemark;
    do {
        nextRemark = [self nextDecodedRemark:consumableRemarks];
        if (nextRemark) [decodedRemarks addObject:nextRemark];
    } while (nextRemark);
    
    if (consumableRemarks.length > 0) {
        UnknownRemark *leftover = [[UnknownRemark alloc] initFromRemarks:consumableRemarks forMETAR:self];
        leftover.remark = consumableRemarks;
        [decodedRemarks addObject:leftover];
    }

    // sort by urgent, then caution, then informative, then unknown

    [decodedRemarks sortUsingComparator:^NSComparisonResult(Remark *r1, Remark *r2) {
        if (r1.urgency > r2.urgency) return NSOrderedAscending;
        if (r1.urgency < r2.urgency) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    return decodedRemarks;
}

- (Remark *) nextDecodedRemark:(NSMutableString *)remarks {
    if (remarks.length == 0) return nil;
    
    Remark *decoded = nil;
    for (NSString *subclassName in [Remark subclasses]) {
        Class subclass = NSClassFromString(subclassName);
        if ((decoded = [[subclass alloc] initFromRemarks:remarks forMETAR:self]))
            break;
    }
    
    return decoded;
}

@end
