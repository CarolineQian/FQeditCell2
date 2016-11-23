//
//  ViewController.m
//  FQeditCell
//
//  Created by 冯倩 on 2016/11/15.
//  Copyright © 2016年 冯倩. All rights reserved.
//

#import "ViewController.h"
#import "MessageListCell.h"                         //自定义 cell
#import "messageDetailController.h"                 //详情Controller

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView              *_messageListTableView;     //主 tableView
    UIButton                 *_editBtn;                  //右上角编辑按钮
    UIButton                 *_selectDeleteButton;       //编辑状态下删除按钮
//    NSInteger                 _currentRow;                //记录你当前选择器的行数
    NSArray                  *_dataArray;                //假数据数组
    NSMutableArray           *_selectArray;              //选中的数据数组
    BOOL                      _editing;                  //是否是编辑状态
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    //initData
    [self initData];
    //navigation
    [self navigationUI];
    //tableView
    [self tableViewUI];
    //ToolBar
    [self toolBarUI];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - InitData
- (void)initData
{
//    //初始化其他数据
//    _currentRow = 0;
    //初始化假数据数组
    _dataArray = @[@"1111111111111111111111111111111111111111111111111111111111”",
                   @"22222222222222222222222222222222222222222222222222222222222",
                   @"333333333333333333333333333333333333333333333333333333333333",
                   @"444444444444444444444444444444444444444444444444444444444444",
                   @"555555555555555555555555555555555555555555555555555555555555",
                   @"666666666666666666666666666666666666666666666666666666666666",
                   @"777777777777777777777777777777777777777777777777777777777777",
                   @"888888888888888888888888888888888888888888888888888888888888",
                   @"999999999999999999999999999999999999999999999999999999999999"
                   ];
    //初始化选择数据数组
    _selectArray = [[NSMutableArray alloc] init];
}

#pragma mark - LayoutUI
- (void)navigationUI
{
    _editBtn = [[UIButton alloc] init];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn sizeToFit];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItems = @[editItem];
}

- (void)tableViewUI
{
    _messageListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStyleGrouped];
    _messageListTableView.backgroundColor = [UIColor clearColor];
    _messageListTableView.dataSource = self;
    _messageListTableView.delegate = self;
    [self.view addSubview:_messageListTableView];
}

- (void)toolBarUI
{
    CGFloat itemWidth = (self.view.frame.size.width - 50) / 3;
    //标记已读
    UIButton *marketButton= [UIButton buttonWithType:UIButtonTypeSystem];
    marketButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [marketButton setTitle:@"标记已读" forState:UIControlStateNormal];
    [marketButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [marketButton addTarget:self action:@selector(marketButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [marketButton sizeToFit];
    UIBarButtonItem *marketItem = [[UIBarButtonItem alloc] initWithCustomView:marketButton];
    marketItem.width = itemWidth;
    
    //删除
    _selectDeleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectDeleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_selectDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_selectDeleteButton addTarget:self action:@selector(selectDeleteItemAction) forControlEvents:UIControlEventTouchUpInside];
    [_selectDeleteButton sizeToFit];
    UIBarButtonItem *selectDeleteItem = [[UIBarButtonItem alloc] initWithCustomView:_selectDeleteButton];
    selectDeleteItem.width = itemWidth;
    //默认灰色不可点击
    [_selectDeleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _selectDeleteButton.enabled = NO;
    
    //全部删除
    UIButton *allDeleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    allDeleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [allDeleteButton setTitle:@"全部删除" forState:UIControlStateNormal];
    [allDeleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [allDeleteButton addTarget:self action:@selector(allDeleteItemAction) forControlEvents:UIControlEventTouchUpInside];
    [allDeleteButton sizeToFit];
    UIBarButtonItem *allDeleteItem = [[UIBarButtonItem alloc] initWithCustomView:allDeleteButton];
    allDeleteItem.width = itemWidth;
    
    self.toolbarItems = @[marketItem,selectDeleteItem,allDeleteItem];
}

#pragma mark - Methods
- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    if (!_editing)
    {
        //编辑状态
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    else
    {
        [_editBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    if (_editing) [_selectArray removeAllObjects];
    
    [_messageListTableView reloadData];
    [_selectDeleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _selectDeleteButton.enabled = NO;
}


#pragma mark - Action
- (void)editBtnAction:(UIButton *)button
{
    
    [self setEditing:!_editing];
    //    NSLog(@"选择后tableView的默认编辑状态为%d",_messageListTableView.editing);
    //    //1,非编辑状态下
    //    if (button.selected)
    //    {
    //        //UI
    //        [button setTitle:@"编辑" forState:UIControlStateNormal];
    //        //取消编辑
    //        _messageListTableView.editing = NO;
    //    }
    //    //0,初始为0,编辑状态下
    //    else
    //    {
    //        //UI
    //        [button setTitle:@"取消" forState:UIControlStateNormal];
    //        //可以编辑
    //        _messageListTableView.editing = YES;
    //    }
    //
    //    //Toolbar的隐藏与显示
    //    [self.navigationController setToolbarHidden:button.selected animated:YES];
    //
    //
    //    for (int i = 0; i < _dataArray.count; i++)
    //    {
    //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:i];
    //        MessageListCell *cell = [_messageListTableView cellForRowAtIndexPath:indexPath];
    //        cell.editSelected = 0;
    //        [cell.selectedImageEdit setImage: [UIImage imageNamed:(@"未点击")]];
    //    }
    //    [_messageListTableView reloadData];
    //
    //    //更改按钮的选中状态
    //    button.selected = !button.selected;
    
}

- (void)marketButtonAction
{
    NSLog(@"标记已读网络请求");
    [self setEditing:NO];
}

- (void)selectDeleteItemAction
{
    NSLog(@"部分删除网络请求,你要删除的数组是%@",_selectArray);
    [self setEditing:NO];
}

- (void)allDeleteItemAction
{
    NSLog(@"全部删除网络请求");
    [self setEditing:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MessageListId";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = _dataArray[indexPath.section];
    
    cell.selectedImageEdit.hidden = !_editing;
    cell.selectedImageEdit.image = [_selectArray containsObject:_dataArray[indexPath.section]] ? [UIImage imageNamed:(@"点击")] : [UIImage imageNamed:@"未点击"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
////编辑时前面的图片为系统自带的圈圈
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}

//非编辑状态下点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editing)
    {
        if([_selectArray containsObject:_dataArray[indexPath.section]])
            [_selectArray removeObject:_dataArray[indexPath.section]];
        else
            [_selectArray addObject:_dataArray[indexPath.section]];
        [_messageListTableView reloadData];
        [_selectDeleteButton setTitleColor:_selectArray.count > 0 ?[UIColor redColor]  : [UIColor lightGrayColor] forState:UIControlStateNormal];
        _selectDeleteButton.enabled = _selectArray.count > 0 ? YES : NO;
    }
    else
    {
        messageDetailController *vc = [[messageDetailController alloc] init];
        vc.messageDetail = _dataArray[indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



//#pragma mark - FQDelegate
//- (void)passValue:(BOOL)editSelected withCell:(MessageListCell *)cell;
//{
//    NSIndexPath *indexPath = [_messageListTableView indexPathForCell:cell];
//    if(editSelected)
//    {
//        NSLog(@"取消选中");
//        [_selectArray removeObject:_dataArray[indexPath.section]];
//        [_selectDeleteButton setTitleColor:_selectArray.count > 0 ? [UIColor redColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
//        _selectDeleteButton.enabled = _selectArray.count > 0 ? YES : NO;
//    }
//    else
//    {
//        NSLog(@"选中");
//        [_selectArray addObject:_dataArray[indexPath.section]];
//        [_selectDeleteButton setTitleColor:_selectArray.count > 0 ? [UIColor redColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
//        _selectDeleteButton.enabled = _selectArray.count > 0 ? YES : NO;
//    }
//
//    //UI
//    [cell.selectedImageEdit setImage:[UIImage imageNamed:(editSelected ? @"未点击" : @"点击" )]];
//    //点击状态改变
//    cell.editSelected = !cell.editSelected;
//}
//


@end
