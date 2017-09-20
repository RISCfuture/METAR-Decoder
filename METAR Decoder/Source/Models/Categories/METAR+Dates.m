#import "METAR+Dates.h"

@implementation METAR (Dates)

@dynamic calendar;
@dynamic timeOnlyFormatter;

- (NSDateComponents *) dateFromString:(NSString *)dateString {
    NSDateComponents *date = nil;
    // hhmm
    if (dateString.length == 4) {
        NSInteger hours = [dateString substringWithRange:NSMakeRange(0, 2)].integerValue;
        NSInteger minutes = [dateString substringWithRange:NSMakeRange(2, 2)].integerValue;
        date = [self dateWithHours:hours minutes:minutes];
    }
    // mm
    else if (dateString.length == 2) {
        NSInteger minutes = [dateString substringWithRange:NSMakeRange(0, 2)].integerValue;
        date = [self dateWithMinutes:minutes];
    }
    
    return date;
}

- (NSDateComponents *) dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes {
    NSDateComponents *components = [self.date copy];
    components.minute = minutes;
    components.hour = hours;
    return components;
}

- (NSDateComponents *) dateWithMinutes:(NSInteger)minutes {
    NSDateComponents *components = [self.date copy];
    components.minute = minutes;
    return components;
}

static NSCalendar *calendar = nil;
- (NSCalendar *) calendar {
    if (!calendar)
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return calendar;
}

static NSDateFormatter *timeOnlyFormatter;
- (NSDateFormatter *) timeOnlyFormatter {
    if (!timeOnlyFormatter) {
        timeOnlyFormatter = [NSDateFormatter new];
        timeOnlyFormatter.dateFormat = @"h:mm a";
    }
    return timeOnlyFormatter;
}

@end
