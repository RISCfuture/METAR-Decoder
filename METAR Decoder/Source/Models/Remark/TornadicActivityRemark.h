typedef enum _TornadicType {
    TornadicTypeTorando = 0,
    TornadicTypeFunnelCloud,
    TornadicTypeWaterspout
} TornadicType;

@interface TornadicActivityRemark : Remark

@property (assign) TornadicType type;
@property (strong) NSDateComponents *beginTime;
@property (strong) NSDateComponents *endTime;
@property (assign) RemarkLocation location;
@property (assign) RemarkDirection movingDirection;

@end
