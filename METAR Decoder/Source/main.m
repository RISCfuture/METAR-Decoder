int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *airportCode;

        if (argc == 1) {
            printf("Enter the ICAO code of an airport to decode or a METAR string.\n");
            char code[256];
            scanf("%256[^\n]", code);
            airportCode = [NSString stringWithCString:code encoding:NSASCIIStringEncoding];
        }
        else {
            airportCode = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
        }

        METARDecoder *decoder = [METARDecoder new];
        METAR *METAR;
        if (airportCode.length <= 4) {
            METAR = [decoder loadMETARForAirport:airportCode];
        } else {
            METAR = [decoder parseMETAR:airportCode];
        }

        //NSLog(@"%@", METAR);
        
        if (!METAR) {
            printf("Bad airport code or METAR\n");
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

