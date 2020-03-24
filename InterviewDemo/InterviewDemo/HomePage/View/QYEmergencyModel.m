//
//  QYEmergencyModel.m
//  QYStaging
//
//  Created by wangkai on 2017/4/10.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYEmergencyModel.h"

@implementation QYEmergencyModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self){
        self.ssoId = [aDecoder decodeObjectForKey:@"ssoId"];
        self.iceType = [aDecoder decodeObjectForKey:@"iceType"];
        self.iceName = [aDecoder decodeObjectForKey:@"iceName"];
        self.iceIdCard = [aDecoder decodeObjectForKey:@"iceIdCard"];
        self.icePhone = [aDecoder decodeObjectForKey:@"icePhone"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ssoId forKey:@"ssoId"];
    [aCoder encodeObject:self.iceType forKey:@"iceType"];
    [aCoder encodeObject:self.iceName forKey:@"iceName"];
    [aCoder encodeObject:self.iceIdCard forKey:@"iceIdCard"];
    [aCoder encodeObject:self.icePhone forKey:@"icePhone"];
}

@end
