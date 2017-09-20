#import "Rational.h"

NSInteger gcd(NSInteger a, NSInteger b);

NSString *RationalSuperscript(NSInteger numerator);
NSString *RationalSubscript(NSUInteger denominator);

@interface Rational (Private)

- (void) simplify;

@end

@implementation Rational

@synthesize numerator;
@synthesize denominator;

- (instancetype) init {
    if (self = [super init]) {
        self.numerator = 1;
        self.denominator = 1;
    }
    return self;
}

- (instancetype) initWith:(NSInteger)num over:(NSUInteger)den {
    if (self = [self init]) {
        self.numerator = num;
        self.denominator = den;
    }
    return self;
}

- (float) floatValue {
    if (self.denominator == 0) return nanf("");
    return (float)self.numerator/(float)self.denominator;
}

- (double) doubleValue {
    if (self.denominator == 0) return nan("");
    return (double)self.numerator/(double)self.denominator;
}

- (NSString *) stringValue {
    [self simplify];
    
    NSString *representation = nil;
    
    switch (self.denominator) {
        case 0: return @"NaN";
        case 1: return representation = [NSString stringWithFormat:@"%du", abs((int)self.numerator)];
        case 2:
            if (self.numerator == 1) representation = @"½";
            break;
        case 3:
            if (self.numerator == 1) representation = @"⅓";
            if (self.numerator == 2) representation = @"⅔";
            break;
        case 4:
            if (self.numerator == 1) representation = @"¼";
            if (self.numerator == 3) representation = @"¾";
            break;
        case 5:
            if (self.numerator == 1) representation = @"⅕";
            if (self.numerator == 2) representation = @"⅖";
            if (self.numerator == 3) representation = @"⅗";
            if (self.numerator == 4) representation = @"⅘";
            break;
        case 6:
            if (self.numerator == 1) representation = @"⅙";
            if (self.numerator == 5) representation = @"⅚";
            break;
        case 8:
            if (self.numerator == 1) representation = @"⅛";
            if (self.numerator == 3) representation = @"⅜";
            if (self.numerator == 5) representation = @"⅝";
            if (self.numerator == 7) representation = @"⅞";
            break;
    }
    if (!representation)
        representation = [NSString stringWithFormat:@"%@⁄%@", RationalSuperscript(self.numerator), RationalSubscript(self.denominator)];
    
    NSString *sign = (self.numerator < 0 ? @"−" : @"");
    return [NSString stringWithFormat:@"%@%@", sign, representation];
}

- (NSString *) ASCIIStringValue {
    [self simplify];
    
    if (self.denominator == 0) return @"NaN";
    
    if (self.denominator == 1)
        return [NSString stringWithFormat:@"%ld", self.numerator];
    else
        return [NSString stringWithFormat:@"%ld/%lu", self.numerator, self.denominator];
}

@end

@implementation Rational (Private)

- (void) simplify {
    if (self.denominator == 0) return;
    if (self.numerator == 0) {
        self.denominator = 1;
        return;
    }
    
    self.numerator /= gcd(self.numerator, self.denominator);
    self.denominator /= gcd(self.numerator, self.denominator);
}

@end

/* Standard C Function: Greatest Common Divisor */
NSInteger gcd(NSInteger a, NSInteger b) {
    NSInteger c;
    while (a != 0) {
        c = a; a = b%a;  b = c;
    }
    return b;
}

NSString *RationalSuperscript(NSInteger numerator) {
    switch (numerator) {
        case 0: return @"⁰";
        case 1: return @"¹";
        case 2: return @"²";
        case 3: return @"³";
        case 4: return @"⁴";
        case 5: return @"⁵";
        case 6: return @"⁶";
        case 7: return @"⁷";
        case 8: return @"⁸";
        case 9: return @"⁹";
        default: return @"?";
    }
}

NSString *RationalSubscript(NSUInteger denominator) {
    switch (denominator) {
        case 0: return @"₀";
        case 1: return @"₁";
        case 2: return @"₂";
        case 3: return @"₃";
        case 4: return @"₄";
        case 5: return @"₅";
        case 6: return @"₆";
        case 7: return @"₇";
        case 8: return @"₈";
        case 9: return @"₉";
        default: return @"?";
    }
}
