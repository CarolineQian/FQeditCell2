//
//  MessageListCell.h
//  yindou
//
//  Created by 冯倩 on 16/8/23.
//  Copyright © 2016年 Beijing Orient Wealth information technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageListCell;


@interface MessageListCell : UITableViewCell

@property (nonatomic, strong)   UIImageView     *selectedImageEdit;     //编辑状态下图标
@property (nonatomic, strong)   UIView          *contentMainView;       //白色View
@property (nonatomic, strong)   UILabel         *messageLabel;          //红点
@property (nonatomic, copy)     NSString        *title;                 //标题内容
@property (nonatomic, copy)     NSString        *content;               //主体内容
@end
