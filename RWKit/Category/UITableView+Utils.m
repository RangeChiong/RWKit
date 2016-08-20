//
//  UITableView+Utils.m
//  findproperty
//
//  Created by Ranger on 16/8/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

- (void)registerCellFromXib:(Class)cls {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cls)];
}

@end
