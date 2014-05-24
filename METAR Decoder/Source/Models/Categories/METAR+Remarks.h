@interface METAR (Remarks)

- (NSArray *) decodedRemarks;
- (Remark *) nextDecodedRemark:(NSMutableString *)remarks;

@end
