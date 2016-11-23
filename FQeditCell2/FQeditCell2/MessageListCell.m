//
//  MessageListCell.m
//  yindou
//
//  Created by 冯倩 on 16/8/23.
//  Copyright © 2016年 Beijing Orient Wealth information technology Ltd. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell
{
    UILabel         *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    //contentView
    _contentMainView = [[UIView alloc] init];
    _contentMainView.layer.masksToBounds = YES;
    _contentMainView.layer.cornerRadius = 8;
    _contentMainView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentMainView];
    
    //标题label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blackColor];
    [_contentMainView addSubview:_titleLabel];
    
    //选中图标ImageView
    _selectedImageEdit = [[UIImageView alloc] init];
    [_selectedImageEdit setImage:[UIImage imageNamed:@"点击"]];
    [self.contentView addSubview:_selectedImageEdit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_selectedImageEdit sizeToFit];
    _selectedImageEdit.center = CGPointMake(15 + _selectedImageEdit.width / 2, self.height / 2);
    
    
    CGFloat x = _selectedImageEdit.hidden ? 15 : (_selectedImageEdit.right + 15);
    
    _contentMainView.frame = CGRectMake(x, 15, self.width - x - 15, self.height - 15 * 2);
    
    
    _messageLabel.center = CGPointMake(15 / 2, _contentMainView.height / 2);
    
    _titleLabel.frame = CGRectMake(15, 8, _contentMainView.width - 15 * 2, _contentMainView.height - 8 * 2);
}

- (void)dealloc
{
    _contentMainView = nil;
    _titleLabel      = nil;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    [_titleLabel setText:title];
}

@end
