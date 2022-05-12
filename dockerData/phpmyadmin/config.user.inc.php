<?php

$cfg['DefaultConnectionCollation'] = 'utf8mb4_general_ci';

$i++;
$cfg['Servers'][$i]['verbose'] = 'LOCALHOST';
$cfg['Servers'][$i]['host'] = 'mysql_dev';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = 'root';

/*

YOU CAN CONFIGURE MULTIPLE SERVERS HERE IF NEEDED

$i++;
$cfg['Servers'][$i]['verbose'] = 'SOME OTHER SERVER';
$cfg['Servers'][$i]['host'] = '.....................';
$cfg['Servers'][$i]['port'] = 3306;
$cfg['Servers'][$i]['connect_type'] = 'port';
$cfg['Servers'][$i]['extension'] = 'mysql';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = '..........';
$cfg['Servers'][$i]['password'] = '....................';


*/
