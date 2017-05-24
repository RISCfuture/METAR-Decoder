@interface METAR : NSObject

@property (strong) NSString *airport;
@property (strong) NSDateComponents *date;
@property (strong) NSString *codedData;
@property (strong) NSString *remarks;

- (id) initWithString:(NSString *)METARString;

@end
