@interface METAR (Dates)

- (NSDateComponents *) dateFromString:(NSString *)dateString;
- (NSDateComponents *) dateWithMinutes:(NSInteger)minutes;
- (NSDateComponents *) dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes;

@property (readonly) NSCalendar *calendar;
@property (readonly) NSDateFormatter *timeOnlyFormatter;

@end
