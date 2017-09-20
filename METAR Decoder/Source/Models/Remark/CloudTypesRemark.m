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

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:CloudTypesRegex];
        if (!match) return (self = nil);
        
        NSString *codedLow = [remarks substringWithRange:[match rangeAtIndex:1]];
        self.low = codedLow.intValue;
        
        NSString *codedMid = [remarks substringWithRange:[match rangeAtIndex:2]];
        if ([codedMid isEqualToString:@"/"]) self.middle = MiddleObscured;
        else self.middle = codedMid.intValue;
        
        NSString *codedHigh = [remarks substringWithRange:[match rangeAtIndex:3]];
        if ([codedHigh isEqualToString:@"/"]) self.high = HighObscured;
        else self.high = codedHigh.intValue;
        
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
        lowString = MDLocalizedString(@"METAR.Remark.CloudTypes.Low.None", nil);
    else
        lowString = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.CloudTypes.Low", nil),
                     [self localizedLowCloudType:self.low]];
    
    NSString *midString;
    if (self.middle == MiddleObscured)
        midString = MDLocalizedString(@"METAR.Remark.CloudTypes.Middle.Obscured", nil);
    else if (self.middle == MiddleNone)
        midString = MDLocalizedString(@"METAR.Remark.CloudTypes.Middle.None", nil);
    else midString = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.CloudTypes.Middle", nil),
                      [self localizedMiddleCloudType:self.middle]];
    
    NSString *highString;
    if (self.high == HighObscured)
        highString = MDLocalizedString(@"METAR.Remark.CloudTypes.High.Obscured", nil);
    else if (self.high == HighNone)
        highString = MDLocalizedString(@"METAR.Remark.CloudTypes.High.None", nil);
    else highString = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.CloudTypes.High", nil),
                       [self localizedHighCloudType:self.high]];
    
    return [@[lowString, midString, highString]
            componentsJoinedByString:MDLocalizedString(@"Common.ListSeparator", nil)];
}

- (NSString *) localizedLowCloudType:(LowCloudType)type {
    switch (type) {
        case LowCbCal:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CbCal", nil);
        case LowCbCap:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CbCap", nil);
        case LowCuHum:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CuHum", nil);
        case LowCuMedOrCon:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CuMedCon", nil);
        case LowCuPlusSc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CuSc", nil);
        case LowNone:
            return nil;
        case LowObscured:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Obscured", nil);
        case LowSc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Sc", nil);
        case LowScCugen:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.ScCugen", nil);
        case LowStFra:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.StFra", nil);
        case LowStNeb:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.StNeb", nil);
    }
}

- (NSString *) localizedMiddleCloudType:(MiddleCloudType)type {
    switch (type) {
        case MiddleObscured:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Obscured", nil);
        case MiddleAc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Ac", nil);
        case MiddleAcCasOrFlo:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcCasFlo", nil);
        case MiddleAcChaoticSky:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Chaotic", nil);
        case MiddleAcCugen:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcCugen", nil);
        case MiddleAcLen:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcLen", nil);
        case MiddleAcPe:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcPe", nil);
        case MiddleAcPlusAcAs:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcPlusAcAs", nil);
        case MiddleAsOp:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AcOp", nil);
        case MiddleAsTr:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.AsTr", nil);
        case MiddleNone:
            return nil;
    }
}

- (NSString *) localizedHighCloudType:(HighCloudType)type {
    switch (type) {
        case HighObscured:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Obscured", nil);
        case HighCc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.Cc", nil);
        case HighCiFib:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CiFib", nil);
        case HighCiInc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CiInc", nil);
        case HighCiSpi:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CiSpi", nil);
        case HighCiUnc:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CiUnc", nil);
        case HighCsIncreasingGreater45:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CsIncG45", nil);
        case HighCsIncreasingLess45:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CsIncL45", nil);
        case HighCsPartialCover:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CsPartial", nil);
        case HighCsTotalCover:
            return MDLocalizedString(@"METAR.Remark.CloudTypes.Type.CsTotal", nil);
        case HighNone:
            return nil;
    }
}

@end
