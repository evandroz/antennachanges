var searchData=
[
  ['l_1790',['L',['../cgcalc2_8m.html#a67824ecf84f5816f07b74fa956bdbcd2',1,'cgcalc2.m']]],
  ['l_1791',['l',['../quaternion_8m.html#a055a2ba98e94309ddf906a782db439fe',1,'quaternion.m']]],
  ['len_1792',['len',['../quaternion_8m.html#aee63acd8d58fcb16d69ab09bec843473',1,'len():&#160;quaternion.m'],['../quaterniondemo2_8m.html#a8eb39ddb0a13eb98fdec1d61e330ccbb',1,'len():&#160;quaterniondemo2.m']]],
  ['len_3c_200_20dim_3dfind_28siz_20_3e_3d_2dlen_2c_201_2c_20_27first_27_29_3belse_20dim_3dfind_28siz_3d_3dlen_2c_201_2c_20_27first_27_29_3bendif_20isempty_28dim_29_20dim_3d0_3bendif_20dim_3c_202_20aout_3dain_3bperm_3d1_20_3andm_3belse_25_20permute_20so_20that_20dim_20becomes_20the_20first_20dimension_20perm_3d_5bdim_20_3andm_2c_201_20_3adim_2d1_5d_3baout_3dpermute_28ain_2c_20perm_29_3bendend_20_25_20finddimfunction_20s_3dsgn_28x_29_25_20function_20s_3dsgn_28x_29_2c_20if_20x_20_3e_3d0_2c_20s_3d1_2c_20else_20s_3d_2d1s_3dones_28size_28x_29_29_3bs_28x_3c_200_29_3d_2d1_3bend_20_25_20sgnfunction_5bu_2c_20n_5d_3dunitvector_28v_2c_20dim_29_25_20function_5bu_2c_20n_5d_3dunitvector_28v_2c_20dim_29_25_20inputs_3a_25_20v_20matrix_20of_20vectors_25_20dim_5boptional_5d_20dimension_20to_20normalize_2c_20dim_20_3e_1793',['len&lt; 0 dim=find(siz &gt;=-len, 1, &apos;first&apos;);else dim=find(siz==len, 1, &apos;first&apos;);endif isempty(dim) dim=0;endif dim&lt; 2 aout=ain;perm=1 :ndm;else% Permute so that dim becomes the first dimension perm=[dim :ndm, 1 :dim-1];aout=permute(ain, perm);endend % finddimfunction s=sgn(x)% function s=sgn(x), if x &gt;=0, s=1, else s=-1s=ones(size(x));s(x&lt; 0)=-1;end % sgnfunction[u, n]=unitvector(v, dim)% function[u, n]=unitvector(v, dim)% Inputs:% v matrix of vectors% dim[OPTIONAL] dimension to normalize, dim &gt;',['../quaternion_8m.html#a486f46411e2db8fb3d3586271bb1f8e0',1,'quaternion.m']]],
  ['length_1794',['length',['../quaternion_8m.html#ab6971d02bd34c9866ba696029ed87744',1,'quaternion.m']]],
  ['linearspeed_1795',['linearspeed',['../cgcalc2_8m.html#af26d9ba67ac0b6cdef7a8d74d0bb1efa',1,'cgcalc2.m']]],
  ['linewidth_1796',['lineWidth',['../data_import_8m.html#a5a74a6860cfd55545040d29e1709584a',1,'dataImport.m']]],
  ['listing_1797',['listing',['../data_import_8m.html#afeb3ee5fe76291f19b5aae1bdf9b122d',1,'dataImport.m']]],
  ['ll_1798',['LL',['../quaterniondemo_8m.html#a185f2f4be923b7fe060a456a65f8b131',1,'quaterniondemo.m']]],
  ['lq_1799',['lq',['../quaternion_8m.html#a96135a7b659062db97bd3c8f41f859a8',1,'quaternion.m']]],
  ['lx_1800',['lx',['../quaternion_8m.html#af7c2dc72bb970fef4e6313293cadfe95',1,'quaternion.m']]]
];
