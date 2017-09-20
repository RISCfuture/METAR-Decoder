@interface METAR (Remarks)

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *decodedRemarks;
- (Remark *) nextDecodedRemark:(NSMutableString *)remarks;

@end
