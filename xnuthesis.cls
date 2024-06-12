\ProvidesExplClass{xnuthesis}{2024/05/20}{1.0.0}{this is a XNXYthesis}
\NeedsTeXFormat{LaTeX2e}

\RequirePackage{expl3}
\RequirePackage{xparse}
%==========ctex宏包加载
\PassOptionsToClass{
zihao=-4,
a4paper,
scheme = plain,
linespread=1.38373,
fontset=fandol
}{ctexart}

\AddToHook{package/xeCJK/after}{\defaultCJKfontfeatures{}}%去除警告
\LoadClass{ctexart}
\cs_new:Nn \ctex_set_name:nn
{
    \keys_set_known:nn{ctex}
    {
        #1 = #2,
    }
}
%======页面风格
\RequirePackage{geometry}
\geometry{
    top           = 3.0 cm,
    bottom        = 2.0 cm,
    left          = 2.6 cm,
    right         = 2.4 cm,
}
%================字体
\PassOptionsToPackage{no-math}{fontspec} %用来加载外部字体的
\RequirePackage{fontspec}
\tl_set:Nn \encodingdefault { T1 } %编码方式
\RequirePackage { newtxtext,newtxmath }      %英文使用新罗马字体
\cs_undefine:N \Bbbk     %解决Bbbk已定义

\tl_new:N \g_sec_title_fmt_tl
\tl_set:Nn \g_sec_title_fmt_tl {\zihao{-3} \sffamily}

%=====默认行间距由ctex决定，暂时用间距变量调整章节标题与正文间的间距======

\dim_new:N  \l_tmp_line_skip 
\dim_set:Nn \l_tmp_line_skip { 20  bp }
%=========页码及目录

\ctex_set_name:nn{contentsname}{
    \centerline{\zihao{3}  目\quad 录}
}

\RequirePackage{titletoc} 
\NewDocumentCommand \tableContents {}{
 \titlecontents{section}[0pt]
 {   \zihao{4}   \sffamily }
 { \thecontentslabel \hspace{0.5em}}
 {\zihao{4}  \sffamily }
{ \normalfont \titlerule*[2mm]{.}\contentspage }

\titlecontents{subsection}[0pt]
 {\zihao{4}}
 {\thecontentslabel \hspace{0.5em}}
 {}
{\titlerule*[2mm]{.}\contentspage}

\titlecontents{subsubsection}[0pt]
 {\zihao{4}}
 {\thecontentslabel \hspace{0.5em}}
 {}
{\titlerule*[2mm]{.}\contentspage}

\pagenumbering{gobble}
\tableofcontents
\newpage
}


\DeclareDocumentCommand {\frontmatter} {}
{
     \setcounter{page}{1}
     \pagenumbering { Roman }
}
\DeclareDocumentCommand {\mainmatter} {}
{
    \setcounter{page}{1}
    \pagenumbering{arabic}
}
%=============中英文摘要
\DeclareDocumentEnvironment { abstract } {O{ zh } +b }
{
\newpage
{\centering   
\str_if_eq:nnTF {#1} {en}
    {
        \section*{ \g_sec_title_fmt_tl  \bfseries ABSTRACT}
        \addcontentsline{toc}{section}{Abstact}
    }
    {
      \section*{ \g_sec_title_fmt_tl  摘\quad 要}
       \addcontentsline{toc}{section}{摘要}
    }
}
#2
}{\newpage}
\NewDocumentCommand{\keywords}{s m m m g g g g}{      %3~7个关键词
\par
\IfBooleanTF{#1}{\vspace{\l_tmp_line_skip} {\bfseries Keywords:~}}{{\sffamily \zihao{-4}{关键词：}}}
\seq_clear:N \l_words_seq 
\clist_map_inline:nn {#2,#3,#4,#5,#6,#7,#8}
{
     \IfNoValueF{##1}{\seq_put_right:Nn \l_words_seq {##1}}{}
}
\seq_use:Nn \l_words_seq {；}
}
%============章节标题设置
\ctex_set:nn { section }
{
afterindent = true,
format = \g_sec_title_fmt_tl,
beforeskip=20 bp,
afterskip = 20bp,
}


\ctex_set:nn { subsection }
{
afterindent = true,
format = \zihao{4} \sffamily ,
beforeskip=20bp ,
afterskip = 6bp,

}
\ctex_set:nn { subsubsection }
{
afterindent = true,
format = \zihao{-4} \sffamily ,
beforeskip=6bp ,
afterskip = 6bp
}

%=================浮动体
\RequirePackage{caption}
\ctex_set_name:nn {tablename}{表}
\ctex_set_name:nn {figurename}{图}

\DeclareCaptionFormat{fivepoint@fmt}{\zihao{5} \sffamily #1#2#3}
\captionsetup
{
    format=fivepoint@fmt,
    justification = centering,
    labelsep=quad
}

%============公式,证明与定理(动态加载)
\RequirePackage{mathtools}
\numberwithin{equation}{section}
\PassOptionsToPackage
 {amsmath,thmmarks}{ntheorem}
\ctex_at_end_package:nn { ntheorem }{
\theoremheaderfont { \bfseries  \sffamily }
\theorembodyfont   { \normalfont }
\theoremseparator{：}
\theoremsymbol{\ensuremath{\square}}
\newtheorem*{proof}{证明}
\theoremsymbol{}
\newtheorem*{solution}{解}
\cs_new:Npn \l_parsing_parameters:nn #1#2
{
    \newtheorem {#1}{#2}[section]
}
\clist_map_inline:nn{
    { assumption  } { 假设        } ,
    { axiom       } { 公理        } ,
    { conjecture  } { 猜想        } ,
    { corollary   } { 推论        } ,
    { definition  } { 定义        } ,
    { example     } { 例          } ,
    { exercise    } { 练习        } ,
    { lemma       } { 引理        } ,
    { problem     } { 问题        } ,
    { proposition } { 命题        } ,
    { remark      } { 注释        } ,
    { theorem     } { 定理        }
}{\l_parsing_parameters:nn #1}

}




%===================参考文献与附录

\ctex_set_name:nn {bibname}{\centerline{ \g_sec_title_fmt_tl 参考文献}}

\ctex_set_name:nn {appendixname}{附录}
\ctex_set:nn{appendix}
{
    name =\appendixname,
    number =\@Alph \c@section
}
\NewDocumentCommand{\printreferences}{}{\printbibliography \newpage}
%====================致谢
\NewDocumentEnvironment {acknowledgements} {+b}
{
\newpage
    {\centering \section*{ \g_sec_title_fmt_tl 致\quad 谢}}
    \addcontentsline{toc}{section}{致谢}
    #1
}{\newpage}
%创建一个数据库info，用来存基本信息basic
\clist_new:N \g_basic_item_clist
\clist_set:Nn \g_basic_item_clist
{
session,
id , 
displaytitle,
title, 
author,
department,
major, 
supervisor, 
assocsupervisor, 
date
}
\clist_map_inline:Nn \g_basic_item_clist
{ 
    \keys_define:nn {info}{#1 .tl_set:c = tl#1} %随时可以使用\tl#1命令
}
\NewDocumentCommand{\xnxyInfo }{m}{\keys_set:nn {info}{#1}}


