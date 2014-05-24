@interface UnknownRemark : Remark

@property (strong) NSMutableString *remark;

- (void) appendWord:(NSString *)word;

@end
