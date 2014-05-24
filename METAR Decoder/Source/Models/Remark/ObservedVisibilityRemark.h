typedef enum _VisibilitySource {
    VisibilitySourceTower = 0,
    VisibilitySourceSurface
} VisibilitySource;

@interface ObservedVisibilityRemark : Remark

@property (assign) VisibilitySource source;
@property (strong) ImproperFraction *distance;

@end
