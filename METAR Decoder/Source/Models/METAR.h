@interface METAR : NSObject

@property (strong) NSString *airport;
@property (strong) NSDateComponents *date;
@property (strong) NSString *codedData;
@property (strong) NSString *remarks;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithString:(NSString *)METARString NS_DESIGNATED_INITIALIZER;

@end
