#import "ThunderstormBeginEndRemark.h"

// TSB0159E30
static NSString *ThunderstormBeginEndRegex = @"\\bTS" THUNDERSTORM_BEGIN_END_EVENT_REGEX @"(?:" THUNDERSTORM_BEGIN_END_EVENT_REGEX @")?\\b\\s*";

typedef enum _ThunderstormEventType {
    ThunderstormEventTypeBegan = 0,
    ThunderstormEventTypeEnded
} ThunderstormEventType;

@interface ThunderstormEvent: NSObject

@property (assign) ThunderstormEventType type;
@property (strong) NSDateComponents *date;

@end

@implementation ThunderstormEvent

@synthesize type;
@synthesize date;

@end

@interface ThunderstormBeginEndRemark (Private)

- (ThunderstormEvent *) parseEventFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)remarks;

@end

@implementation ThunderstormBeginEndRemark

@synthesize events;

+ (void) load {
    [Remark registerSubclass:self];
}

- (id) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        events = [NSMutableArray new];

        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ThunderstormBeginEndRegex];
        if (!match) return (self = nil);

        ThunderstormEvent *event1 = [self parseEventFromMatch:match index:1 inString:remarks];
        if (event1) [self.events addObject:event1];
        ThunderstormEvent *event2 = [self parseEventFromMatch:match index:4 inString:remarks];
        if (event2) [self.events addObject:event2];

        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyCaution;
}

- (NSString *) stringValue {
    NSMutableArray *eventDescriptions = [NSMutableArray new];
    [self.events enumerateObjectsUsingBlock:^(ThunderstormEvent *event, NSUInteger eventIndex, BOOL *stop) {
        NSString *description;
        switch (event.type) {
            case ThunderstormEventTypeBegan:
                if (eventIndex == 0)
                    description = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ThunderstormBeginEnd.Type.Began", @"{time}"),
                                                  [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:event.date]]];
                else
                    description = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ThunderstormBeginEnd.Type.BeganAgain", @"{time}"),
                                   [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:event.date]]];
                break;
            case ThunderstormEventTypeEnded:
                description = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ThunderstormBeginEnd.Type.Ended", @"{time}"),
                               [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:event.date]]];
                break;
        }
        [eventDescriptions addObject:description];
    }];

    NSString *combinedDescriptions = [eventDescriptions componentsJoinedByString:MDLocalizedString(@"Common.PairSeparator", nil)];
    return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.ThunderstormsBeginEnd", @"{began/ended string}"), combinedDescriptions];
}

@end

@implementation ThunderstormBeginEndRemark (Private)

- (ThunderstormEvent *)parseEventFromMatch:(NSTextCheckingResult *)match index:(NSUInteger)index inString:(NSString *)remarks {
    if ([match rangeAtIndex:index].location == NSNotFound) return nil;

    ThunderstormEvent *event = [ThunderstormEvent new];

    NSString *eventTypeString = [remarks substringWithRange:[match rangeAtIndex:index]];
    if ([eventTypeString isEqualToString:@"B"]) event.type = ThunderstormEventTypeBegan;
    else if ([eventTypeString isEqualToString:@"E"]) event.type = ThunderstormEventTypeEnded;
    else return nil;

    event.date = [self.parent parseDateFromMatch:match index:index+1 inString:remarks];

    return event;
}

@end
