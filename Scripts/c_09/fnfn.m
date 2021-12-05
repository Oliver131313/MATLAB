function varargout=fnfn(funhandle,varargin)
% Funkcia fnfn vykresli graf zadanej funkcie (na stanovenom intervale
% definicneho oboru), prip. defaultne na intervale [0,10].
%
% Povinne vstupy:
% funhandle ...   "rukovat" funkcie (=function handle).
%
% Dalsie (nepovinne) vstupy (MATLAB ich ulozi do pola buniek 'varargin'):
% bounds ...        vektor s dolnou a hornou medzou intervalu definicneho
%                   oboru, na ktorom sa ma vykreslit priebeh funkcie (napr.
%                   bounds=[-10 10]). Defaultne nastavene na interval [0, 10].
%
% Nepovinne vystupy (MATLAB ich ulozi do pola buniek 'varargout'):
% graph_handle ...   "rukovat" vytvoreneho grafu (=graph handle).
%
% Mozne formaty volania funkcie:
% Minimalne fungujuce pouzitie funkcie:
%       fnfn(funhandle)
%       napr.: fnfn(@sin)
% Plne definovane vsutpy a vystupy funkcie:
%       graph_handle=fnfn(funhandle,bounds);
%       napr.: graf1=fnfn(@cos,[-5 5])


if nargin==2
    x1=varargin{1}(1);
    x2=varargin{1}(2);
    x=linspace(x1,x2,100);
elseif nargin==1
    x=0:.25:10;
else
    warning('Zadali ste nepripustny pocet vstupov funkcie. Prosim nastudujte si napovedu k funkcii (ziskate ju napr. prikazom "help(fnfn)").')
end
y=funhandle(x);


if nargout>1
    warning('Zadali ste nepripustny pocet vystupov funkcie. Prosim nastudujte si napovedu k funkcii (ziskate ju napr. prikazom "help(fnfn)").')
elseif nargout==1
    figure
    varargout{1}=plot(x,y);
    xlabel('x')
    ylabel('fn(x)')
    title(func2str(funhandle))
else
    figure
    plot(x,y);
    xlabel('x')
    ylabel('fn(x)')
    title(func2str(funhandle))
end
end