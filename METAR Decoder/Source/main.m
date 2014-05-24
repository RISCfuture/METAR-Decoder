int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc == 1) {
            printf("Enter the ICAO code of an airport to decode.\n");
            exit(1);
        }
        
        NSString *airportCode = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        METARDecoder *decoder = [METARDecoder new];
        METAR *METAR = [decoder loadMETARForAirport:airportCode];
        
        if (!METAR) {
            printf("Bad airport code\n");
            exit(1);
        }
        
        for (Remark *remark in [METAR decodedRemarks]) {
            NSString *prefix = @"R";
            if (remark.urgency == UrgencyCaution) prefix = @"C";
            if (remark.urgency == UrgencyUrgent) prefix = @"U";
            if (remark.urgency == UrgencyUnknown) prefix = @"?";
            printf("(%s) %s\n", [prefix cStringUsingEncoding:NSUTF8StringEncoding],
                   [[remark stringValue] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
    return 0;
}

