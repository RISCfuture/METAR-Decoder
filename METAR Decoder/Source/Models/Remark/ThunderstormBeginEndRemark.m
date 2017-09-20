#import "ThunderstormBeginEndRemark.h"

// TSB0159E30
static NSString *ThunderstormBeginEndRegex = @"\\bTS(" THUNDERSTORM_BEGIN_END_EVENT_REGEX @")+\\b\\s*";

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

- (void) parseEventsFromMatch:(NSTextCheckingResult *)match inString:(NSString *)remarks;

@end

@implementation ThunderstormBeginEndRemark

@synthesize events;

+ (void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        events = [NSMutableArray new];

        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:ThunderstormBeginEndRegex];
        if (!match) return (self = nil);

        [self parseEventsFromMatch:match inString: remarks];

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

- (void) parseEventsFromMatch:(NSTextCheckingResult *)match inString:(NSString *)remarks {
    if ([match rangeAtIndex:0].location == NSNotFound) return;
    NSString *eventsString = [remarks substringWithRange:[match rangeAtIndex:0]];
    NSUInteger index = 2;

    while (index + 3 < eventsString.length) {
        NSString *eventString = [eventsString substringWithRange:NSMakeRange(index, 3)];
        ThunderstormEvent *event = [self parseEvent:eventString];
        if (event) [self.events addObject:event];
        index += 3;
    }
}

- (ThunderstormEvent *)parseEvent:(NSString *)eventString {
    ThunderstormEvent *event = [ThunderstormEvent new];

    NSString *eventTypeString = [eventString substringWithRange:NSMakeRange(0, 1)];
    if ([eventTypeString isEqualToString:@"B"]) event.type = ThunderstormEventTypeBegan;
    else if ([eventTypeString isEqualToString:@"E"]) event.type = ThunderstormEventTypeEnded;
    else return nil;

    NSString *dateString = [eventString substringFromIndex:1];
    event.date = [self.parent dateFromString:dateString];

    return event;
}

@end
