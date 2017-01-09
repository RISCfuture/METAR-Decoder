int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *airportCode;

        if (argc == 1) {
            printf("Enter the ICAO code of an airport to decode.\n");
            char code[5];
            scanf("%4s", code);
            airportCode = [NSString stringWithCString:code encoding:NSASCIIStringEncoding];
        }
        else {
            airportCode = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        }

        METARDecoder *decoder = [METARDecoder new];
        METAR *METAR = [decoder loadMETARForAirport:airportCode];
        NSLog(@"%@", METAR);
        
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

