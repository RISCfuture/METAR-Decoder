#import "PrecipitationBeginEndRemark.h"

// RAB05E30SNB20E55
// SHRAB05E30SHSNB20E55
// RAB0456E09B26
#define NOCAP_TIME_REGEX @"(?:\\d{2})?\\d{2}"
#define NOCAP_PRECIP_ELEMENT_REGEX @"(?:" NOCAP_PRECIPITATION_DESCRIPTOR_REGEX ")?(?:" NOCAP_PRECIPITATION_TYPE_REGEX @")(?:[BE]" NOCAP_TIME_REGEX @")+"
static NSString *PrecipitationBeginEndRegex = @"(" NOCAP_PRECIP_ELEMENT_REGEX @")+\\b\\s*";
static NSString *PrecipitationElementRegex = PRECIPITATION_DESCRIPTOR_REGEX @"?" PRECIPITATION_TYPE_REGEX @"((?:[BE]" NOCAP_TIME_REGEX @")+)";
static NSString *PrecipitationEventRegex = @"([BE])" REMARK_TIME_REGEX;

@implementation PrecipitationEvent

@synthesize time;
@synthesize precipitationType;
@synthesize eventType;
@synthesize descriptor;

- (id) copy {
    PrecipitationEvent *copy = [PrecipitationEvent new];
    copy.time = [self.time copy];
    copy.precipitationType = self.precipitationType;
    copy.eventType = self.eventType;
    copy.descriptor = self.descriptor;
    return copy;
}

@end

@implementation PrecipitationBeginEndRemark

@synthesize events;

+(void) load {
    [Remark registerSubclass:self];
}

- (instancetype) initFromRemarks:(NSMutableString *)remarks forMETAR:(METAR *)METAR {
    if (self = [super initFromRemarks:remarks forMETAR:METAR]) {
        NSTextCheckingResult *match = [self matchRemarks:remarks withRegex:PrecipitationBeginEndRegex];
        if (!match) return (self = nil);
        
        NSString *codedElements = [remarks substringWithRange:match.range];
        NSMutableArray *newEvents = [NSMutableArray new];
        
        NSError *error = nil;
        NSRegularExpression *elementExpression = [[NSRegularExpression alloc] initWithPattern:PrecipitationElementRegex options:0 error:&error];
        if (error) return (self = nil);
        [elementExpression enumerateMatchesInString:codedElements
                                            options:0
                                              range:NSMakeRange(0, codedElements.length)
                                         usingBlock:^(NSTextCheckingResult *elementMatch, NSMatchingFlags flags, BOOL *stop) {
                                             PrecipitationEvent *templateEvent = [PrecipitationEvent new];
                                             NSString *codedEvents = [codedElements substringWithRange:elementMatch.range];
                                             
                                             if ([elementMatch rangeAtIndex:1].location != NSNotFound) {
                                                 NSString *codedDescriptor = [codedElements substringWithRange:[elementMatch rangeAtIndex:1]];
                                                 templateEvent.descriptor = [self.parent decodePrecipitationDescriptor:codedDescriptor];
                                             }
                                             else templateEvent.descriptor = DescriptorUnspecified;
                                             
                                             NSString *codedType = [codedElements substringWithRange:[elementMatch rangeAtIndex:2]];
                                             templateEvent.precipitationType = [self.parent decodePrecipitationType:codedType];
                                             
                                             NSError *error = nil;
                                             NSRegularExpression *eventExpression = [[NSRegularExpression alloc] initWithPattern:PrecipitationEventRegex options:0 error:&error];
                                             if (error) return;
                                             [eventExpression enumerateMatchesInString:codedEvents
                                                                               options:0
                                                                                 range:NSMakeRange(0, codedEvents.length)
                                                                            usingBlock:^(NSTextCheckingResult *eventMatch, NSMatchingFlags flags, BOOL *stop) {
                                                                                PrecipitationEvent *event = [templateEvent copy];
                                                                                NSString *codedEventType = [codedEvents substringWithRange:[eventMatch rangeAtIndex:1]];
                                                                                if ([codedEventType isEqualToString:@"B"])
                                                                                    event.eventType = EventBegan;
                                                                                else event.eventType = EventEnded;
                                                                                event.time = [self.parent parseDateFromMatch:eventMatch index:2 inString:codedEvents];
                                                                                [newEvents addObject:event];
                                                                            }];
                                             
                                         }];
        
        if (newEvents.count == 0) return (self = nil);
        self.events = [NSArray arrayWithArray:newEvents];
        
        [remarks deleteCharactersInRange:match.range];
    }
    return self;
}

- (RemarkUrgency) urgency {
    return UrgencyRoutine;
}

- (NSString *) stringValue {
    NSArray *strings = [events map:^id(PrecipitationEvent *event) {
        NSString *precipString;
        if (event.descriptor != DescriptorUnspecified)
            precipString = [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PrecipitationBeginEnd.Description", @"{descriptor}, {type}"),
                            [self.parent localizedPrecipitationDescriptor:event.descriptor],
                            [self.parent localizedPrecipitationType:event.precipitationType]];
        else precipString = [self.parent localizedPrecipitationType:event.precipitationType];
        
        switch (event.eventType) {
            case EventBegan:
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PrecipitationBeginEnd.Began", @"{precipitation}, {time}"),
                        precipString,
                        [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:event.time]]];
            case EventEnded:
                return [NSString localizedStringWithFormat:MDLocalizedString(@"METAR.Remark.PrecipitationBeginEnd.Ended", @"{precipitation}, {time}"),
                        precipString,
                        [self.parent.timeOnlyFormatter stringFromDate:[self.parent.calendar dateFromComponents:event.time]]];
        }
    }];
    
    return [strings componentsJoinedByString:MDLocalizedString(@"Common.ListSeparator", nil)];
}

@end
