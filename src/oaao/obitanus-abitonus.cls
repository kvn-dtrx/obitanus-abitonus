\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{obitanus-abitonus}[%
    2025/08/01 A simple LaTeX template for obituaries%
]

% ---

% Not strictly necessary … rather a warning.
% expl3 – Wrapper package for experimental LaTeX3.
\RequirePackage{expl3}

% ---

% Engine Check — LuaLaTeX required

% iftex – Am I running under pdfTeX, XeTeX or LuaTeX?
\RequirePackage{iftex}

% Aborts if engine is not LuaLaTeX.
\ifLuaTeX
    % The desired case; nothing to do.
\else
    \ClassError{hpx}{%
        This class requires LuaLaTeX for Unicode and OpenType support.%
    }{%
        Please specify LuaLaTeX as compilation engine.%
    }
\fi

% ---

% Document Information

\ExplSyntaxOn

% Creates a global property list to hold document information.
\prop_new:N \g_oaao_doc_info_prop

% Defines keys.
\keys_define:nn { oaao/doc-info } {
    name .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { name } {#1} },
    name .initial:n = { <Name> },

    birth .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { birth } {#1} },
    birth .initial:n = { <Birth> },

    death .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { death } {#1} },
    death .initial:n = { <Death> },

    birthsymbol .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { birthsymbol } {#1} },
    birthsymbol .initial:n = { <Birthsymbol> },

    deathsymbol .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { deathsymbol } {#1} },
    deathsymbol .initial:n = { <Deathsymbol> },

    dictum .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { dictum } {#1} },
    dictum .initial:n = { <Dictum> },

    dictumref .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { dictumref } {#1} },
    dictumref .initial:n = { <Dictumref> },

    mourners .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { mourners } {#1} },
    mourners .initial:n = { <Mourners> },

    mournersprefix .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { mournersprefix } {#1} },
    mournersprefix .initial:n = { <Mournersprefix> },

    spacetime .code:n = { \prop_put:Nnn \g_oaao_doc_info_prop { spacetime } {#1} },
    spacetime .initial:n = { <Spacetime> },
}

\AtBeginDocument{
    \clist_new:N \l_oaao_info_keys_clist
    \clist_set:Nn \l_oaao_info_keys_clist
    {
        name,
        birth,death,
        birthsymbol,deathsymbol,
        dictum,dictumref,
        mourners,mournersprefix,
        spacetime
    }
    \clist_map_inline:Nn \l_oaao_info_keys_clist
    {
        \prop_get:NnN \g_oaao_doc_info_prop { #1 } \l_tmpa_tl
        \tl_set:Nx \l_tmpb_tl { \tl_upper_case:n { \tl_head:n {#1} } \tl_tail:n {#1} }
        \tl_set:cx { oaao\l_tmpb_tl } { \tl_use:N \l_tmpa_tl }
    }
}

% User macro for setting values of oc/doc-info.
\NewDocumentCommand \oaaoDocInfo { m }
{ \keys_set:nn { oaao/doc-info } { #1 } }

\ExplSyntaxOff

% ---

% Class and Package Loading with Options

% scrartcl – Koma-Script ‘article’ class
\LoadClass[%
    parskip={half},%
    fontsize={11pt},%
    % visualise,%
]{scrartcl}

% geometry – Flexible and complete interface to document dimensions
\RequirePackage{geometry}
\geometry{%
    paperwidth={160mm},%
    paperheight={160mm},%
    inner={10mm},%
    outer={10mm},%
    top={10mm},%
    bottom={10mm},%
}

% fontspec – Advanced font selection in XeLaTeX and LuaLaTeX.
\RequirePackage{fontspec}

\setmainfont{Libertinus Serif}[
    Numbers={
            OldStyle,
            Proportional,
        },
]
% \setsansfont{Libertinus Sans}
% \setmonofont{Libertinus Mono}

% % Select sans serif font as default.
% \renewcommand*{\familydefault}{\sfdefault}

% microtype – Subliminal refinements towards typographical perfection.
\RequirePackage{microtype}

% graphbox – Extend graphicx to improve placement of graphics.
\RequirePackage{graphbox}

% tikz – Create PostScript and PDF graphics in TeX.
\RequirePackage{tikz}

% ---

% \pagestyle{empty}

\newlength{\bordersep}
\setlength{\bordersep}{3mm}

\newlength{\borderwidth}
\setlength{\borderwidth}{2mm}

\newcommand*{\MakeObituaryPrintBGLayer}{%
    \begin{tikzpicture}[overlay, remember picture]
        \draw[
            black,
            rounded corners={0mm},
            line width={\borderwidth},
        ]
        ([xshift=\bordersep, yshift=-\bordersep]current page.north west)
        -- ([xshift=-\bordersep, yshift=-\bordersep]current page.north east)
        -- ([xshift=-\bordersep, yshift=\bordersep]current page.south east)
        -- ([xshift=\bordersep, yshift=\bordersep]current page.south west)
        -- cycle;
    \end{tikzpicture}%
}

\AddToHook{shipout/background}{\MakeObituaryPrintBGLayer}

% ---

\NewDocumentCommand{\MakeObituary}{m}{%
    % \thispagestyle{empty}
    \vspace*{\fill}
    \begin{center}
        \begin{minipage}{0.9\textwidth}
            \centering
            % Name
            {\fontsize{36}{42}\selectfont\oaaoName\par\vspace{0.5em}}

            % Birth and death
            {\fontsize{16}{20}\selectfont
                \oaaoBirthsymbol\,\oaaoBirth
                \qquad
                \oaaoDeathsymbol\,\oaaoDeath
                \par\vspace{2em}
            }

            % Dictum
            \ifx\oaaodictum\empty\else
                ``\oaaoDictum''\par
            \fi

            % Dictum reference
            \ifx\oaaodictumref\empty\else
                {\small
                    \begin{flushright}
                        ---~\oaaoDictumref
                    \end{flushright}
                    \vspace{2.5em}}
            \fi

            % Mourners
            \ifx\oaaomourners\empty\else
                {\bfseries\oaaoMournersprefix\par
                    \smallskip
                    \oaaoMourners
                    \vspace{0.5em}}
            \fi

            % Spacetime
            \begin{flushright}
                \oaaoSpacetime
            \end{flushright}
        \end{minipage}
    \end{center}
    \vspace*{\fill}
    \clearpage
}
