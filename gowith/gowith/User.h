//
//  User.h
//  goWith
//
//  Created by Nikhil Sharma on 14/3/15.
//  Copyright (c) 2015 goWith. All rights reserved.
//

#import "MCModel.h"

@interface User : MCModel

@property (nonatomic, assign) NSInteger uuid;
@property (nonatomic, copy) NSString *facebookId;

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, strong) NSDate *birthDate;

@property (nonatomic, copy) NSString *email;


@end
