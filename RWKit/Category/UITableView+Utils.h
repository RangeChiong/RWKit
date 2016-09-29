//
//  UITableView+Utils.h
//  findproperty
//
//  Created by Ranger on 16/8/20.
//  Copyright © 2016年 Centaline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)

- (void)rw_registerCellXib:(Class)cls;

- (void)rw_registerCellClass:(Class)cls;

@end
