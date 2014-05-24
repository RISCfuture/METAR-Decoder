#import "CloudTypesRemark.h"

// 8/6//
// 8/903
static NSString *CloudTypesRegex = @"\\b8\\/(\\d)(\\d|\\/)(\\d|\\/)\\s*";

@implementation CloudTypesRemark

@synthesize low;
@synthesize middle;
@synthesize high;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:CloudTypesRegex];
        if (!match) return (self = nil);
        
        NSString *codedLow = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.low = [codedLow intValue];
        
        NSString *codedMid = [remarks substringWithRange:[match rangeAtIndex:2]];
        if ([codedMid isEqualToString:@"/"]) self.middle = MiddleObscured;
        else self.middle = [codedMid intValue];
        
        NSString *codedHigh = [remarks substringWithRange:[match rangeAtIndex:3]];
        if ([codedHigh isEqualToString:@"/"]) self.high = HighObscured;
        else self.high = [codedHigh intValue];
        
        [remarks deleteCharactersInRange:match.range];

    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    NSString *lowString;
    if (self.low == LowNone)
        lowString = NSLocalizedString(@"no low clouds observed", @"cloud type remark");
    else
        lowString = [NSString localizedStringWithFormat:NSLocalizedString(@"low %@ clouds", @"cloud type remark"),
                     [self localizedLowCloudType:self.low]];
    
    NSString *midString;
    if (self.middle == MiddleObscured)
        midString = NSLocalizedString(@"middle clouds obscured", @"cloud type remark");
    else if (self.middle == MiddleNone)
        midString = NSLocalizedString(@"no middle clouds observed", @"cloud type remark");
    else midString = [NSString localizedStringWithFormat:NSLocalizedString(@"middle %@ clouds", @"cloud type remark"),
                      [self localizedMiddleCloudType:self.middle]];
    
    NSString *highString;
    if (self.high == HighObscured)
        highString = NSLocalizedString(@"high clouds obscured", @"cloud type remark");
    else if (self.high == HighNone)
        highString = NSLocalizedString(@"no high clouds observed", @"cloud type remark");
    else highString = [NSString localizedStringWithFormat:NSLocalizedString(@"high %@ clouds", @"cloud type remark"),
                       [self localizedHighCloudType:self.high]];
    
    return [@[lowString, midString, highString]
            componentsJoinedByString:NSLocalizedString(@", ", @"list separator")];
}

- (NSString *) localizedLowCloudType:(LowCloudType)type {
    switch (type) {
        case LowCbCal:
            return NSLocalizedString(@"cumulonimbus calvus", @"cloud type");
        case LowCbCap:
            return NSLocalizedString(@"cumulonimbus capillatus", @"cloud type");
        case LowCuHum:
            return NSLocalizedString(@"cumulus humilis", @"cloud type");
        case LowCuMedOrCon:
            return NSLocalizedString(@"cumulus mediocris or cumulus congestus", @"cloud type");
        case LowCuPlusSc:
            return NSLocalizedString(@"cumulus and stratocumulus", @"cloud type");
        case LowNone:
            return nil;
        case LowObscured:
            return NSLocalizedString(@"obscured", @"cloud type");
        case LowSc:
            return NSLocalizedString(@"stratocumulus", @"cloud type");
        case LowScCugen:
            return NSLocalizedString(@"stratocumulus cumulogenitus", @"cloud type");
        case LowStFra:
            return NSLocalizedString(@"stratus fractus", @"cloud type");
        case LowStNeb:
            return NSLocalizedString(@"stratus nebulosus", @"cloud type");
    }
}

- (NSString *) localizedMiddleCloudType:(MiddleCloudType)type {
    switch (type) {
        case MiddleObscured:
            return NSLocalizedString(@"obscured", @"cloud type");
        case MiddleAc:
            return NSLocalizedString(@"altocumulus", @"cloud type");
        case MiddleAcCasOrFlo:
            return NSLocalizedString(@"altocumulus castellanus or altocumulus floccus", @"cloud type");
        case MiddleAcChaoticSky:
            return NSLocalizedString(@"chaotic", @"cloud type");
        case MiddleAcCugen:
            return NSLocalizedString(@"altocumulus cumulogenitus", @"cloud type");
        case MiddleAcLen:
            return NSLocalizedString(@"altocumulus lenticularis", @"cloud type");
        case MiddleAcPe:
            return NSLocalizedString(@"altocumulus perlucidus", @"cloud type");
        case MiddleAcPlusAcAs:
            return NSLocalizedString(@"altocumulus plus altocumulus/altostratus", @"cloud type");
        case MiddleAsOp:
            return NSLocalizedString(@"altostratus opacus", @"cloud type");
        case MiddleAsTr:
            return NSLocalizedString(@"altostratus translucidus", @"cloud type");
        case MiddleNone:
            return nil;
    }
}

- (NSString *) localizedHighCloudType:(HighCloudType)type {
    switch (type) {
        case HighObscured:
            return NSLocalizedString(@"obscured", @"cloud type");
        case HighCc:
            return NSLocalizedString(@"cirrocumulus", @"cloud type");
        case HighCiFib:
            return NSLocalizedString(@"cirrus fibratus", @"cloud type");
        case HighCiInc:
            return NSLocalizedString(@"cirrus incus", @"cloud type");
        case HighCiSpi:
            return NSLocalizedString(@"cirrus spissatus", @"cloud type");
        case HighCiUnc:
            return NSLocalizedString(@"cirrus uncinus", @"cloud type");
        case HighCsIncreasingGreater45:
            return NSLocalizedString(@"cirrostratus increasing > 45° above horizon", @"cloud type");
        case HighCsIncreasingLess45:
            return NSLocalizedString(@"cirrostratus increasing < 45° above horizon", @"cloud type");
        case HighCsPartialCover:
            return NSLocalizedString(@"cirrostratus with partial coverage", @"cloud type");
        case HighCsTotalCover:
            return NSLocalizedString(@"cirrostratus with total coverage", @"cloud type");
        case HighNone:
            return nil;
    }
}

@end
