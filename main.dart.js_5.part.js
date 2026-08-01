((a,b)=>{a[b]=a[b]||{}})(self,"$__dart_deferred_initializers__")
$__dart_deferred_initializers__.current=function(a,b,c,$){var J,B,C,A={bt:function bt(){},
Y1(d,e){var x,w,v
if(d===e)return!0
x=J.ag(d)
w=J.ag(e)
if(x.gp(d)!==w.gp(e))return!1
for(v=0;v<x.gp(d);++v)if(!A.bnN(x.cN(d,v),w.cN(e,v)))return!1
return!0},
c_d(d,e){var x
if(d===e)return!0
if(d.gp(d)!==e.gp(e))return!1
for(x=d.gZ(d);x.u();)if(!e.kw(0,new A.bi7(x.gN(x))))return!1
return!0},
bZ9(d,e){var x,w,v,u
if(d===e)return!0
x=J.ag(d)
w=J.ag(e)
if(x.gp(d)!==w.gp(e))return!1
for(v=J.b5(x.gda(d));v.u();){u=v.gN(v)
if(!w.az(e,u)||!A.bnN(x.i(d,u),w.i(e,u)))return!1}return!0},
bnN(d,e){var x
if(d==null?e==null:d===e)return!0
if(typeof d=="number"&&typeof e=="number")return!1
else{x=y.E
if(x.b(d))x=x.b(e)
else x=!1
if(x)return J.f(d,e)
else{x=y.Z
if(x.b(d)&&x.b(e))return A.c_d(d,e)
else{x=y.N
if(x.b(d)&&x.b(e))return A.Y1(d,e)
else{x=y.G
if(x.b(d)&&x.b(e))return A.bZ9(d,e)
else{x=d==null?null:J.a6(d)
if(x!=(e==null?null:J.a6(e)))return!1
else if(!J.f(d,e))return!1}}}}}return!0},
bmV(d,e){var x,w,v,u={}
u.a=d
u.b=e
if(y.G.b(e)){C.d.aG(A.bss(J.Cc(e),new A.bf4(),y.z),new A.bf5(u))
return u.a}x=y.Z.b(e)?u.b=A.bss(e,new A.bf6(),y.z):e
if(y.N.b(x)){for(x=J.b5(x);x.u();){w=x.gN(x)
v=u.a
u.a=(v^A.bmV(v,w))>>>0}return(u.a^J.bO(u.b))>>>0}d=u.a=d+J.P(x)&536870911
d=u.a=d+((d&524287)<<10)&536870911
return d^d>>>6},
bZa(d,e){return d.j(0)+"("+new B.ad(e,new A.bhN(),B.a9(e).h("ad<1,j>")).cC(0,", ")+")"},
bi7:function bi7(d){this.a=d},
bf4:function bf4(){},
bf5:function bf5(d){this.a=d},
bf6:function bf6(){},
bhN:function bhN(){},
bXv(d,e){var x=null
return new A.Qf(e.w,B.aa(e.r,x,x,x,x,x,x,x),x)},
att(d,e,f){var x,w,v,u=B.a8(d.a,e.a,f)
u.toString
x=d.c
w=e.c
v=B.a8(x.c,w.c,f)
v.toString
return new A.tC(u,e.b,new A.w9(w.a,w.b,v,B.a8(x.d,w.d,f)),!0)},
bJJ(d,e,f){var x,w
if(d.k(0,D.bN))return e
if(e.k(0,D.bN))return d
x=B.a8(d.a,e.a,f)
x.toString
w=B.a8(d.b,e.b,f)
w.toString
return new A.eP(x,w)},
c_g(d){return!0},
bXy(d){return D.X5},
bru(d,e,f,g){var x
if(d==null)x=f==null?C.o:null
else x=d
return new A.qG(x,f,g,e)},
bKv(d,e,f){var x,w,v,u=B.a8(d.a,e.a,f)
u.toString
x=B.a8(d.b,e.b,f)
x.toString
w=B.U(d.c,e.c,f)
v=B.qN(d.d,e.d,f)
if(w==null)w=v==null?C.j:null
return new A.mh(u,x,w,v)},
bQd(d,e,f){var x,w,v,u=B.a8(d.a,e.a,f)
u.toString
x=B.a8(d.b,e.b,f)
x.toString
w=B.U(d.c,e.c,f)
v=B.qN(d.d,e.d,f)
if(w==null)w=v==null?C.j:null
return new A.mG(u,x,w,v)},
bKu(d,e,f){var x,w,v,u,t,s=B.a8(d.e,e.e,f)
s.toString
x=d.w
w=e.w
v=B.y2(x.b,w.b,f)
u=B.cm(x.c,w.c,f)
u=A.bKs(B.bj9(x.d,w.d,f),w.e,v,!1,u)
v=B.U(d.a,e.a,f)
w=B.qN(d.b,e.b,f)
x=B.a8(d.c,e.c,f)
x.toString
t=A.pW(d.d,e.d,f,A.bht(),y.S)
if(v==null)v=w==null?C.o:null
return new A.km(s,e.f,e.r,u,e.x,v,w,x,t)},
bQc(d,e,f){var x,w,v,u,t,s=B.a8(d.e,e.e,f)
s.toString
x=d.w
w=e.w
v=B.y2(x.b,w.b,f)
u=B.cm(x.c,w.c,f)
u=A.bQa(B.bj9(x.d,w.d,f),w.e,v,!1,u)
v=B.U(d.a,e.a,f)
w=B.qN(d.b,e.b,f)
x=B.a8(d.c,e.c,f)
x.toString
t=A.pW(d.d,e.d,f,A.bht(),y.S)
if(v==null)v=w==null?C.o:null
return new A.kI(s,e.f,e.r,u,e.x,v,w,x,t)},
bKs(d,e,f,g,h){var x=e==null?A.bWq():e,w=f==null?C.kR:f
return new A.a3r(x,!1,w,h,d==null?C.eI:d)},
bKt(d){return C.c.aB(d.e,1)},
bQa(d,e,f,g,h){var x=e==null?A.bWt():e,w=f==null?C.kR:f,v=h==null?D.aqc:h,u=d==null?D.P6:d
return new A.acy(x,g===!0,w,v,u)},
bQb(d){return C.c.aB(d.e,1)},
bJI(d,e,f){return new A.LB(d,e==null?4:e,f)},
Z3:function Z3(){},
Cs:function Cs(d,e){this.a=d
this.b=e},
AL:function AL(d,e){this.r=d
this.w=e},
w9:function w9(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
aaA:function aaA(){},
tC:function tC(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
DQ:function DQ(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
eP:function eP(d,e){this.a=d
this.b=e},
DP:function DP(d,e,f,g,h,i,j,k,l){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i
_.r=j
_.w=k
_.x=l},
qG:function qG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
OM:function OM(d,e){this.a=d
this.b=e},
mh:function mh(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
mG:function mG(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
km:function km(d,e,f,g,h,i,j,k,l){var _=this
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i
_.b=j
_.c=k
_.d=l},
kI:function kI(d,e,f,g,h,i,j,k,l){var _=this
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.a=i
_.b=j
_.c=k
_.d=l},
a3r:function a3r(d,e,f,g,h){var _=this
_.e=d
_.a=e
_.b=f
_.c=g
_.d=h},
acy:function acy(d,e,f,g,h){var _=this
_.e=d
_.a=e
_.b=f
_.c=g
_.d=h},
Lt:function Lt(d,e,f){this.a=d
this.b=e
this.c=f},
uK:function uK(){},
LB:function LB(d,e,f){this.a=d
this.b=e
this.c=f},
afh:function afh(){},
afl:function afl(){},
ahH:function ahH(){},
ai0:function ai0(){},
ai1:function ai1(){},
ai3:function ai3(){},
ai4:function ai4(){},
ai5:function ai5(){},
aiD:function aiD(){},
aiC:function aiC(){},
aiE:function aiE(){},
alB:function alB(){},
anw:function anw(){},
anx:function anx(){},
apE:function apE(){},
apD:function apD(){},
apF:function apF(){},
atp:function atp(){},
Jv:function Jv(){},
Z4:function Z4(d,e,f){this.c=d
this.d=e
this.a=f},
atr:function atr(d){this.a=d},
atq:function atq(d){this.a=d},
Qf:function Qf(d,e,f){this.c=d
this.e=e
this.a=f},
W5:function W5(d){var _=this
_.d=d
_.c=_.a=_.e=null},
bOd(d,e,f){var x=B.a9(f),w=x.h("ad<1,m8>")
w=B.X(new B.ad(f,new A.aTG(),w),w.h("aA.E"))
x=x.h("ad<1,i>")
x=B.X(new B.ad(f,new A.aTH(),x),x.h("aA.E"))
return new A.aaB(e,d,w,x,null)},
bGg(d,e,f){var x,w=null,v=B.aL(y.I),u=J.hj(4,y.s)
for(x=0;x<4;++x)u[x]=new B.rS(w,C.aE,C.l,new B.jY(1),w,w,w,w,C.b9,w)
v=new A.Z5(f,d,e,v,u,!0,0,w,w,new B.bq(),B.aL(y.v))
v.bw()
return v},
aaB:function aaB(d,e,f,g,h){var _=this
_.e=d
_.f=e
_.r=f
_.c=g
_.a=h},
aTG:function aTG(){},
aTH:function aTH(){},
Z5:function Z5(d,e,f,g,h,i,j,k,l,m,n){var _=this
_.A=d
_.Y=e
_.a3=f
_.ad=g
_.WW$=h
_.aV8$=i
_.dY$=j
_.am$=k
_.e9$=l
_.dy=m
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=n
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
b5t:function b5t(d,e){this.a=d
this.b=e},
ats:function ats(){},
m8:function m8(d,e){this.a=d
this.b=e},
n6:function n6(d,e){this.a=d
this.b=e},
afi:function afi(){},
afj:function afj(){},
afk:function afk(){},
Sg:function Sg(){},
Au:function Au(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aTI:function aTI(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
aTJ:function aTJ(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
brs(d,e){var x=d==null?B.kb(C.o,1):d
return new A.a2B(e!==!1,x)},
Zj:function Zj(){},
a2B:function a2B(d,e){this.a=d
this.b=e},
LI:function LI(){},
a2C:function a2C(){},
atU:function atU(){},
aAq:function aAq(d,e){this.a=d
this.b=e},
afs:function afs(){},
ahY:function ahY(){},
ahZ:function ahZ(){},
ai6:function ai6(){},
JC:function JC(){},
O8:function O8(d,e,f){this.a=d
this.c=e
this.$ti=f},
hu:function hu(){},
a2G:function a2G(d){this.a=d},
a2H:function a2H(d){this.a=d},
a2I:function a2I(d){this.a=d},
LD:function LD(){},
LE:function LE(){},
a2L:function a2L(d){this.a=d},
LG:function LG(){},
LH:function LH(d){this.a=d},
a2F:function a2F(d){this.a=d},
a2E:function a2E(d){this.a=d},
LC:function LC(d){this.a=d},
a2J:function a2J(d){this.a=d},
a2K:function a2K(d){this.a=d},
LF:function LF(d){this.a=d},
FD:function FD(){},
aO2:function aO2(d){this.a=d},
aO3:function aO3(d){this.a=d},
aO4:function aO4(d){this.a=d},
aO5:function aO5(d){this.a=d},
aO6:function aO6(d){this.a=d},
aO7:function aO7(d){this.a=d},
aO8:function aO8(d){this.a=d},
aO9:function aO9(d){this.a=d},
aOa:function aOa(d){this.a=d},
aOb:function aOb(d){this.a=d},
aOc:function aOc(d){this.a=d},
aOd:function aOd(d){this.a=d},
aOe:function aOe(d){this.a=d},
N1:function N1(d,e,f,g,h){var _=this
_.r=d
_.c=e
_.d=f
_.e=g
_.a=h},
U6:function U6(d,e,f,g,h){var _=this
_.cx=_.CW=null
_.cy=d
_.db=e
_.dx=f
_.e=_.d=$
_.hy$=g
_.dd$=h
_.c=_.a=null},
b5A:function b5A(d,e){this.a=d
this.b=e},
b5y:function b5y(d){this.a=d},
b5z:function b5z(d,e){this.a=d
this.b=e},
b5x:function b5x(){},
b5B:function b5B(d){this.a=d},
bkK(d,e,f,g,h,i,j,k,l,m,n,o,p,q,a0,a1,a2){var x=p==null?0/0:p,w=n==null?0/0:n,v=q==null?0/0:q,u=o==null?0/0:o,t=e==null?0:e,s=f==null?0:f,r=d==null?C.y:d
return new A.oX(l,g,m,a1,k,a2,a0,x,w,t,v,u,s,i,r,j,h,m)},
bkJ(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v){var x
if(g==null)x=k==null?D.ahs:null
else x=g
x=new A.ea(v,!0,x,k,e,!0,h,!1,r,!0,!1,f,d==null?A.bjf(!1,null,0,null,!1,D.tl):d,j,u,i,s,!1,p)
x.asG(d,e,f,g,h,i,j,k,!0,!1,!0,!1,p,!1,r,s,!0,u,v)
return x},
bL7(d,e,f){var x,w,v,u,t,s,r,q,p,o,n=B.a8(d.x,e.x,f)
n.toString
x=A.bpY(d.ay,e.ay,f)
w=A.bpY(d.ch,e.ch,f)
v=B.a8(d.as,e.as,f)
v.toString
u=e.CW
t=A.pW(d.cy,e.cy,f,A.bht(),y.S)
s=B.U(d.r,e.r,f)
r=B.qN(d.w,e.w,f)
q=A.pW(d.a,e.a,f,A.bWp(),y.D)
q.toString
p=B.buB(d.db,e.db,f)
p.toString
o=B.a8(d.dy.a,e.dy.a,f)
o.toString
return A.bkJ(w,n,x,s,e.z,t,new A.ye(u.a,u.b,u.c),r,!0,!1,!0,!1,new A.N2(o),!1,v,p,!0,e.cx,q)},
bjf(d,e,f,g,h,i){var x
if(e==null)x=g==null?B.aR(C.c.b1(127.5),D.d7.F()>>>16&255,D.d7.F()>>>8&255,D.d7.F()&255):null
else x=e
return new A.Ze(h,x,g,i,f,!1)},
bpY(d,e,f){var x=e.d,w=d.d.b,v=x.b,u=B.U(w.a,v.a,f),t=B.qN(w.b,v.b,f),s=B.a8(w.c,v.c,f)
s.toString
s=A.bru(u,A.pW(w.d,v.d,f,A.bht(),y.S),t,s)
t=B.U(d.b,e.b,f)
v=B.qN(d.c,e.c,f)
w=B.a8(d.e,e.e,f)
w.toString
return A.bjf(!1,t,w,v,e.a,new A.Jz(!1,s,x.c,!0))},
bGk(d,e,f){var x=B.U(d.c,e.c,f),w=B.qN(d.d,e.d,f)
if(x==null)x=w==null?B.aR(C.c.b1(127.5),D.d7.F()>>>16&255,D.d7.F()>>>8&255,D.d7.F()&255):null
return new A.m9(e.a,e.b,x,w)},
c_h(d){return!0},
bmZ(d,e,f){var x=f.w
if(x!=null)return A.bnG(x.a,A.bkj(x),e/100)
x=f.r
x=x
return x==null?D.d7:x},
bTE(d,e,f){var x,w=f.w
if(w!=null)x=A.bnG(w.a,A.bkj(w),e/100)
else{w=f.r
x=w
if(x==null)x=D.d7}return B.aR(x.gi2(x),C.c.b1(x.gFT()*0.6),C.c.b1(x.gBC()*0.6),C.c.b1(x.gDX()*0.6))},
bx9(d,e,f,g,h){var x,w=A.bmZ(d,e,f),v=f.w
if(v!=null)x=A.bnG(v.a,A.bkj(v),e/100)
else{v=f.r
x=v
if(x==null)x=D.d7}v=B.aR(x.gi2(x),C.c.b1(x.gFT()*0.6),C.c.b1(x.gBC()*0.6),C.c.b1(x.gDX()*0.6))
return new A.LB(w,h==null?4:h,v)},
c_f(d,e){return!0},
bVZ(d,e){return Math.abs(d.a-e.a)},
bXB(d,e){var x=J.l5(e,new A.bgR(d),y.W)
x=B.X(x,x.$ti.h("aA.E"))
return x},
bXx(d,e){return-1/0},
bXw(d,e){return d.a[e].b},
byq(d){var x=J.l5(d,new A.bgO(),y.j)
x=B.X(x,x.$ti.h("aA.E"))
return x},
oX:function oX(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u){var _=this
_.ch=d
_.CW=e
_.cx=f
_.cy=g
_.c=h
_.d=i
_.e=j
_.f=k
_.r=l
_.w=m
_.x=n
_.y=o
_.z=p
_.Q=q
_.as=r
_.at=s
_.a=t
_.b=u},
ea:function ea(d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v){var _=this
_.a=d
_.e=_.d=_.c=_.b=$
_.f=e
_.r=f
_.w=g
_.x=h
_.y=i
_.z=j
_.Q=k
_.as=l
_.at=m
_.ax=n
_.ay=o
_.ch=p
_.CW=q
_.cx=r
_.cy=s
_.db=t
_.dx=u
_.dy=v},
aGq:function aGq(){},
N2:function N2(d){this.a=d},
Ze:function Ze(d,e,f,g,h,i){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h
_.f=i},
m9:function m9(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
Jz:function Jz(d,e,f,g){var _=this
_.a=d
_.b=e
_.c=f
_.d=g},
ye:function ye(d,e,f){this.a=d
this.b=e
this.c=f},
a2D:function a2D(){},
N3:function N3(d,e,f,g,h,i,j,k,l,m,n){var _=this
_.e=d
_.f=e
_.r=f
_.w=g
_.x=h
_.y=i
_.z=j
_.a=k
_.b=l
_.c=m
_.d=n},
bgR:function bgR(d){this.a=d},
bgQ:function bgQ(d){this.a=d},
a4Z:function a4Z(){},
bgO:function bgO(){},
oW:function oW(){},
pC:function pC(d,e,f,g,h,i){var _=this
_.w=d
_.c=e
_.d=f
_.e=g
_.a=h
_.b=i},
r2:function r2(d,e){this.a=d
this.b=e},
rU:function rU(d,e){this.a=d
this.b=e},
G5:function G5(d){this.a=d},
N4:function N4(d){this.a=d},
yS:function yS(d,e){this.a=d
this.b=e},
afo:function afo(){},
afp:function afp(){},
aft:function aft(){},
ai_:function ai_(){},
ai2:function ai2(){},
ajn:function ajn(){},
ajp:function ajp(){},
ajq:function ajq(){},
ajs:function ajs(){},
ajt:function ajt(){},
aju:function aju(){},
ajv:function ajv(){},
anv:function anv(){},
aoY:function aoY(){},
aGr:function aGr(d){this.a=d},
aGs:function aGs(){},
aGt:function aGt(){},
yT:function yT(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
ajr:function ajr(){},
aGu:function aGu(){var _=this
_.e=_.d=_.c=_.b=_.a=_.Q=_.z=_.y=_.x=_.w=_.r=_.f=$},
aGx:function aGx(){},
aGv:function aGv(d,e,f){this.a=d
this.b=e
this.c=f},
aGw:function aGw(d,e,f){this.a=d
this.b=e
this.c=f},
aGy:function aGy(){},
vk:function vk(d,e,f,g){var _=this
_.a=d
_.c=e
_.d=f
_.e=g},
a4Y:function a4Y(d,e,f){this.d=d
this.e=e
this.a=f},
a9j:function a9j(d,e,f,g,h,i,j,k){var _=this
_.h3=d
_.oy=e
_.lY=f
_.jm=g
_.A=h
_.ad=_.a3=_.Y=null
_.al=i
_.c7=_.aV=_.aq=_.aD=$
_.dy=j
_.b=_.fy=null
_.c=0
_.y=_.d=null
_.z=!0
_.Q=null
_.as=!1
_.at=null
_.ay=$
_.ch=k
_.CW=!1
_.cx=$
_.cy=!0
_.db=!1
_.dx=$},
bkj(d){var x,w={}
w.a=B.a([],y.x)
x=d.b
if(x==null||x.length!==d.a.length){x=d.a
if(x.length>1)new B.N6(x,B.a9(x).h("N6<1>")).aG(0,new A.aD_(w,d))
else throw B.d(B.aq('"colors" must have length > 1.',null))}else w.a=x
return w.a},
aD_:function aD_(d,e){this.a=d
this.b=e},
bjB(d,e){var x,w
if(e!=null){x=B.a9(e).h("ad<1,N>")
w=B.X(new B.ad(e,new A.awy(),x),x.h("aA.E"))
return A.bXs(d,new A.ZS(w,y.C))}else return d},
awy:function awy(){},
bOM(d,e){var x=!0
if(d!==C.dU)if(!(d===C.aE&&e===C.l))x=d===C.hP&&e===C.ay
if(x)return D.vX
else{x=!0
if(d!==C.fC)if(!(d===C.hP&&e===C.l))x=d===C.aE&&e===C.ay
if(x)return D.vY
else return D.Xn}},
M8:function M8(d,e){this.a=d
this.b=e},
av1:function av1(d,e){this.a=d
this.b=e},
N8:function N8(d,e){this.a=d
this.$ti=e},
ajB:function ajB(){},
bXs(d,e){var x,w,v,u,t,s,r,q,p,o,n,m=B.cP($.ak().r)
for(x=B.a([],y.A),w=new B.MX(d,!1,x),v=e.a,u=m.e;w.u();){t=w.c
if(t===0||w.f)B.V(B.eS('PathMetricIterator is not pointing to a PathMetric. This can happen in two situations:\n- The iteration has not started yet. If so, call "moveNext" to start iteration.\n- The iterator ran out of elements. If so, check that "moveNext" returns true prior to calling "current".'));--t
s=new B.MW(w,t)
w.DY()
r=x[t].b
r===$&&B.b()
r.a.length()
q=0
p=!0
for(;;){w.DY()
r=x[t].b
r===$&&B.b()
if(!(q<r.a.length()))break
r=e.b
if(r>=v.length)r=e.b=0
e.b=r+1
o=v[r]
if(p){r=new B.Cj(d.aV7(s,q,q+o,!0),C.i,null)
u.push(r)
n=m.d
if(n!=null)r.je(n)}q+=o
p=!p}}return m},
ZS:function ZS(d,e){this.a=d
this.b=0
this.$ti=e},
aXb:function aXb(){},
bOx(){return new A.abj(null)},
BO:function BO(d,e){this.a=d
this.b=e},
abj:function abj(d){this.a=d},
anT:function anT(d){this.a=d},
Wi:function Wi(d){this.a=d},
anU:function anU(d){this.d=d
this.c=this.a=null},
bco:function bco(){},
bcp:function bcp(d){this.a=d},
bcn:function bcn(d,e){this.a=d
this.b=e},
bcl:function bcl(){},
bcm:function bcm(){},
Tu:function Tu(d,e,f){this.c=d
this.d=e
this.a=f},
ahS:function ahS(){this.c=this.a=null},
b2r:function b2r(d){this.a=d},
b2s:function b2s(d){this.a=d},
b2t:function b2t(d){this.a=d},
Bi:function Bi(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
ahT:function ahT(){this.c=this.a=null},
Sz:function Sz(d,e){this.c=d
this.a=e},
afT:function afT(){this.c=this.a=null},
b_K:function b_K(){},
b_I:function b_I(){},
b_J:function b_J(d){this.a=d},
WD:function WD(d,e,f,g){var _=this
_.c=d
_.d=e
_.e=f
_.a=g},
aoV:function aoV(){this.c=this.a=null},
bdI:function bdI(d,e){this.a=d
this.b=e},
bdH:function bdH(){},
B8:function B8(d,e,f,g,h){var _=this
_.c=d
_.d=e
_.e=f
_.f=g
_.a=h},
afR:function afR(){this.c=this.a=null},
lT:function lT(d,e){this.a=d
this.b=e},
kN:function kN(d,e){this.a=d
this.b=e},
bss(d,e,f){var x=B.X(d,f)
C.d.fc(x,e)
return x},
bk8(d){var x,w,v,u,t=y.U,s=B.a([B.a([],t)],y.T)
for(x=d.length,w=0;w<d.length;d.length===x||(0,B.F)(d),++w){v=d[w]
if(v!==D.bN)u=B.G(v)===B.G(D.bN)&&A.Y1(v.gdf(),D.bN.gdf())
else u=!0
if(!u)C.d.gah(s).push(v)
else if(C.d.gah(s).length!==0)s.push(B.a([],t))}if(C.d.gah(s).length===0)s.pop()
return s},
bGo(d){var x,w=d.d
if(w.b===0&&d.a.b===0&&d.b.b===0&&d.c.b===0)return!1
w=w.a
x=!1
if(w.gdV(w)===0){w=d.a.a
if(w.gdV(w)===0){w=d.b.a
if(w.gdV(w)===0){w=d.c.a
w=w.gdV(w)===0}else w=x}else w=x}else w=x
if(w)return!1
return!0},
brt(d){var x=d.a,w=x?d.b.d.b:0,v=x?d.b.a.b:0,u=x?d.b.b.b:0
return new B.aB(w,v,u,x?d.b.c.b:0)},
bk9(d){var x=A.aTF(d.b),w=A.aTF(d.c),v=A.aTF(d.d),u=A.aTF(d.e)
return new B.aB(x,w,v,u)},
bMk(d){var x
if(d.c===0){d.sfb(null)
x=B.bV(d.r)
d.r=B.aR(0,x.F()>>>16&255,x.F()>>>8&255,x.F()&255).gt(0)}},
bl3(d,e,f,g){var x
if(f!=null){d.r=C.o.gt(0)
d.sfb(f.px(0,g))}else{x=e==null?C.y:e
d.r=x.gt(x)
d.sfb(null)}},
aTF(d){var x=d.c
return x.a&&x.c!==0?0+x.c:0},
pW(d,e,f,g,h){var x,w,v,u=d!=null
if(u&&e!=null&&d.length===e.length){x=d.length
w=J.dB(x,h)
for(v=0;v<x;++v)w[v]=g.$3(d[v],e[v],f)
return w}else if(u&&e!=null){x=e.length
w=J.dB(x,h)
for(v=0;v<x;++v){u=v>=d.length?e[v]:d[v]
w[v]=g.$3(u,e[v],f)}return w}else return e},
bYQ(d,e,f){return C.c.b1(d+(e-d)*f)},
bnG(d,e,f){var x,w,v,u,t,s,r,q,p,o,n=d.length
if(e.length!==n){x=J.dB(n,y.i)
for(w=0;w<n;w=v){v=w+1
x[w]=v/n}e=x}for(u=e.length-1,t=0;t<u;t=r){s=e[t]
r=t+1
q=e[r]
p=d[t]
o=d[r]
if(f<=s)return p
else if(f<q){u=B.U(p,o,(f-s)/(q-s))
u.toString
return u}}return C.d.gah(d)}},D,E,G,F
J=c[1]
B=c[0]
C=c[2]
A=a.updateHolder(c[4],A)
D=c[14]
E=c[13]
G=c[8]
F=c[15]
A.bt.prototype={
k(d,e){var x
if(e==null)return!1
if(this!==e)x=y.E.b(e)&&B.G(this)===B.G(e)&&A.Y1(this.gdf(),e.gdf())
else x=!0
return x},
gv(d){var x=B.fN(B.G(this)),w=C.d.hM(this.gdf(),0,A.bXI(),y.S),v=w+((w&67108863)<<3)&536870911
v^=v>>>11
return(x^v+((v&16383)<<15)&536870911)>>>0},
j(d){var x=$.brk
if(x==null){$.brk=!1
x=!1}if(x)return A.bZa(B.G(this),this.gdf())
return B.G(this).j(0)}}
A.Z3.prototype={
gdf(){var x=this
return[x.c,x.d,x.e,x.f,x.r,x.w,x.x,x.y,x.z,x.Q,x.as,x.a,x.b,x.at]}}
A.Cs.prototype={
L(){return"AxisSide."+this.b}}
A.AL.prototype={}
A.w9.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d]}}
A.aaA.prototype={
gdf(){return[!1,0,0,0]}}
A.tC.prototype={
gdf(){return[this.b,this.a,this.c,!0]}}
A.DQ.prototype={
gdf(){var x=this
return[!0,x.b,x.c,x.d,x.e]}}
A.eP.prototype={
j(d){return"("+B.o(this.a)+", "+B.o(this.b)+")"},
gdf(){return[this.a,this.b]}}
A.DP.prototype={
gdf(){var x=this
return[x.a,!0,x.c,x.d,x.e,!0,x.r,x.w,x.x]}}
A.qG.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d]}}
A.OM.prototype={
gdf(){return[this.a,this.b]}}
A.mh.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d]}}
A.mG.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d]}}
A.km.prototype={
gdf(){var x=this
return[x.e,x.w,x.a,x.c,x.d,x.f,x.r,x.x]}}
A.kI.prototype={
gdf(){var x=this
return[x.e,x.w,x.a,x.c,x.d,x.f,x.r,x.x]}}
A.a3r.prototype={
gdf(){var x=this
return[x.e,!1,x.b,x.c,x.d]}}
A.acy.prototype={
gdf(){var x=this
return[x.e,!1,x.b,x.c,x.d]}}
A.Lt.prototype={
gdf(){return[this.a,this.b,!0]}}
A.uK.prototype={}
A.LB.prototype={
aeJ(d,e,f){var x,w
$.ak()
x=B.ba()
w=this.a
x.r=w.gt(w)
x.b=C.bm
d.jk(f,this.b,x)},
gdf(){return[this.a,this.b,this.c,0]}}
A.afh.prototype={}
A.afl.prototype={}
A.ahH.prototype={}
A.ai0.prototype={}
A.ai1.prototype={}
A.ai3.prototype={}
A.ai4.prototype={}
A.ai5.prototype={}
A.aiD.prototype={}
A.aiC.prototype={}
A.aiE.prototype={}
A.alB.prototype={}
A.anw.prototype={}
A.anx.prototype={}
A.apE.prototype={}
A.apD.prototype={}
A.apF.prototype={}
A.atp.prototype={
MV(d,e,f,g,h,i){return new B.k1(this.aYf(d,e,f,g,h,i),y.ad)},
aYe(d,e,f,g){return this.MV(d,e,f,!0,g,!0)},
aYf(d,e,f,g,h,i){return function(){var x=d,w=e,v=f,u=g,t=h,s=i
var r=0,q=1,p=[],o,n,m,l,k,j
return function $async$MV(a0,a1,a2){if(a1===1){p.push(a2)
r=q}for(;;)switch(r){case 0:n=$.q_().akA(t,v,w,x)
m=n===t
l=!s&&m?n+w:n
k=n+C.c.dG(v-t,w)*w===v
j=!u&&k?v-w:v
r=s&&!m?2:3
break
case 2:r=4
return a0.b=t,1
case 4:case 3:o=j+w/1e5
case 5:if(!(l<=o)){r=6
break}r=7
return a0.b=l,1
case 7:l+=w
r=5
break
case 6:r=u&&!k?8:9
break
case 8:r=10
return a0.b=v,1
case 10:case 9:return 0
case 1:return a0.c=p.at(-1),3}}}}}
A.Jv.prototype={
as9(){var x,w=this
$.ak()
x=B.ba()
x.b=C.b8
w.a=x
x=B.ba()
x.b=C.bm
w.b=x
x=B.ba()
x.b=C.bm
w.e=x
x=B.ba()
x.b=C.b8
w.c=x
w.d=B.ba()},
jr(d,e,f){var x=this
x.a0n(d,e,f)
x.aUe(e,f)
x.aUo(e,f)
x.aUm(e,f)},
aUm(a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,a0=a3.a,a1=a0.c
if(!a1.a)return
x=a2.b
w=a1.r
if(w==null)w=$.q_().P_(x.a,a0.r-a0.f)
v=$.bio().MV(a0.w,w,a0.r,!1,a0.f,!1)
for(u=new B.fT(v.a(),v.$ti.h("fT<1>")),t=x.b,s=a1.w,r=a1.x;u.u();){q=u.b
if(!r.$1(q))continue
p=e.f9(q,x,a3)
o=new B.q(p,0)
n=new B.q(p,t)
m=s.$1(q)
q=e.a
q===$&&B.b()
l=m.a
k=m.b
j=B.kw(o,n)
if(k!=null){q.r=C.o.gt(0)
q.sfb(k.px(0,j))}else{if(l==null)l=C.y
q.r=l.gt(l)
q.sfb(d)}l=m.c
q.c=l
if(l===0){q.sfb(d)
l=B.bV(q.r)
q.r=B.aR(0,l.F()>>>16&255,l.F()>>>8&255,l.F()&255).gt(0)}a2.EA(o,n,e.a,m.d)}i=a1.c
if(i==null)i=$.q_().P_(x.b,a0.y-a0.x)
v=$.bio().MV(a0.z,i,a0.y,!1,a0.x,!1)
for(u=new B.fT(v.a(),v.$ti.h("fT<1>")),s=a1.d,h=x.a,a1=a1.e;u.u();){r=u.b
if(!a1.$1(r))continue
g=s.$1(r)
f=e.hF(r,x,a3)
o=new B.q(0,f)
n=new B.q(h,f)
r=e.a
r===$&&B.b()
q=g.a
l=g.b
j=B.kw(o,n)
if(l!=null){r.r=C.o.gt(0)
r.sfb(l.px(0,j))}else{if(q==null)q=C.y
r.r=q.gt(q)
r.sfb(d)}q=g.c
r.c=q
if(q===0){r.sfb(d)
q=B.bV(r.r)
r.r=B.aR(0,q.F()>>>16&255,q.F()>>>8&255,q.F()&255).gt(0)}a2.EA(o,n,e.a,g.d)}},
aUe(d,e){var x,w,v=e.a.as
if((v.F()>>>24&255)/255===0)return
x=d.b
w=this.b
w===$&&B.b()
w.r=v.gt(0)
d.a.iW(new B.I(0,0,0+x.a,0+x.b),this.b)},
aUo(d,e){var x,w,v,u,t,s,r,q,p,o=this,n=d.b,m=e.a.e,l=m.b,k=l.length
if(k!==0)for(x=d.a.a,w=n.b,v=0;v<l.length;l.length===k||(0,B.F)(l),++v){u=l[v]
t=B.kw(new B.q(o.f9(u.a,n,e),0),new B.q(o.f9(u.b,n,e),w))
s=o.e
s===$&&B.b()
r=u.c
q=u.d
if(q!=null){s.r=C.o.gt(0)
s.sfb(q.px(0,t))}else{s.r=(r==null?C.y:r).gt(0)
s.sfb(null)}p=o.e.h5()
x.drawRect(B.dF(t),p)
p.delete()}m=m.a
l=m.length
if(l!==0)for(k=d.a.a,x=n.a,v=0;v<m.length;m.length===l||(0,B.F)(m),++v){u=m[v]
t=B.kw(new B.q(0,o.hF(u.a,n,e)),new B.q(x,o.hF(u.b,n,e)))
w=o.e
w===$&&B.b()
s=u.c
r=u.d
if(r!=null){w.r=C.o.gt(0)
w.sfb(r.px(0,t))}else{w.r=(s==null?C.y:s).gt(0)
w.sfb(null)}p=o.e.h5()
k.drawRect(B.dF(t),p)
p.delete()}},
aUl(d,e,f){var x,w
this.a0n(d,e,f)
x=e.b
w=f.a.at
if(w.a.length!==0)this.aUn(d,e,f,x)
if(w.b.length!==0)this.aUs(d,e,f,x)},
aUn(d,e,f,a0){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g=this
for(x=f.a.at.a,w=x.length,v=a0.a,u=a0.b,t=e.a,s=t.a,r=0;r<x.length;x.length===w||(0,B.F)(x),++r){q=x[r]
p=q.e
o=g.hF(p,a0,f)
n=new B.q(0,o)
p=g.hF(p,a0,f)
m=new B.q(v,p)
if(!(o<0||p<0||o>u||p>u)){o=g.c
o===$&&B.b()
l=q.a
k=q.b
j=B.kw(n,m)
if(k!=null){o.r=C.o.gt(0)
o.sfb(k.px(0,j))}else{if(l==null)l=C.y
o.r=l.gt(l)
o.sfb(null)}l=q.c
o.c=l
if(l===0){o.sfb(null)
l=B.bV(o.r)
o.r=B.aR(0,l.F()>>>16&255,l.F()>>>8&255,l.F()&255).gt(0)}o.d=q.x
e.EA(n,m,g.c,q.d)
o=q.r
i=o.gcv(o).ez(0,2)
h=C.c.W(p,o.gaH(o).ez(0,2))
J.aQ(s.save())
s.translate(i,h)
o=o.gNL().b
o===$&&B.b()
o=o.a
o===$&&B.b()
o=o.a
o.toString
s.drawPicture(o)
s.restore()
o=q.f
i=o.gcv(o).ez(0,2)
p=C.c.W(p,o.gaH(o).ez(0,2))
l=g.d
l===$&&B.b()
t.aeK(0,o,new B.q(i,p),l)}}},
aUs(d,a0,a1,a2){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(x=a1.a.at.b,w=x.length,v=a2.b,u=a2.a,t=a0.a,s=t.a,r=0;r<x.length;x.length===w||(0,B.F)(x),++r){q=x[r]
p=q.e
o=e.f9(p,a2,a1)
n=new B.q(o,0)
p=e.f9(p,a2,a1)
m=new B.q(p,v)
if(!(o<0||p<0||o>u||p>u)){o=e.c
o===$&&B.b()
l=q.a
k=q.b
j=B.kw(n,m)
if(k!=null){o.r=C.o.gt(0)
o.sfb(k.px(0,j))}else{if(l==null)l=C.y
o.r=l.gt(l)
o.sfb(null)}l=q.c
o.c=l
if(l===0){o.sfb(null)
l=B.bV(o.r)
o.r=B.aR(0,l.F()>>>16&255,l.F()>>>8&255,l.F()&255).gt(0)}o.d=q.x
a0.EA(n,m,e.c,q.d)
o=q.r
i=o.gcv(o).ez(0,2)
h=o.gaH(o).ez(0,2)
g=C.c.W(p,i)
f=C.c.W(v,h)
J.aQ(s.save())
s.translate(g,f)
o=o.gNL().b
o===$&&B.b()
o=o.a
o===$&&B.b()
o=o.a
o.toString
s.drawPicture(o)
s.restore()
o=q.f
i=o.gcv(o).ez(0,2)
h=o.gaH(o).a4(0,2)
p=C.c.W(p,i)
l=C.c.W(v,h)
k=e.d
k===$&&B.b()
t.aeK(0,o,new B.q(p,l),k)}}},
f9(d,e,f){var x=f.a,w=x.f,v=x.r-w
if(v===0)return 0
return(d-w)/v*e.a},
hF(d,e,f){var x,w=f.a,v=w.x,u=w.y-v
if(u===0)return e.b
x=e.b
return x-(d-v)/u*x},
alf(d,e,f,g){switch(f.a){case 0:return d-e/2+g
case 2:return d+g
case 1:return d-e+g}}}
A.Z4.prototype={
gamN(){var x=this.d.d.b.c,w=x.a&&x.c!==0
return w},
gamO(){var x=this.d.d.d.c,w=x.a&&x.c!==0
return w},
gamP(){var x=this.d.d.c.c,w=x.a&&x.c!==0
return w},
gamL(){var x=this.d.d.e.c,w=x.a&&x.c!==0
return w},
anc(d){var x,w=this,v=null,u=w.d,t=A.bk9(u.d),s=u.a
s=s.a&&A.bGo(s.b)?s.b:v
x=B.a([B.cq(v,w.c,C.p,v,v,new B.cv(v,v,s,v,v,v,C.Y),v,v,v,t,v,v,v,v)],y.p)
t=new A.atr(x)
if(w.gamN())C.d.iI(x,t.$1(!0),new A.Au(D.tg,u,new B.M(B.S(1/0,d.a,d.b),B.S(1/0,d.c,d.d)),v))
if(w.gamP())C.d.iI(x,t.$1(!0),new A.Au(D.k5,u,new B.M(B.S(1/0,d.a,d.b),B.S(1/0,d.c,d.d)),v))
if(w.gamO())C.d.iI(x,t.$1(!0),new A.Au(D.th,u,new B.M(B.S(1/0,d.a,d.b),B.S(1/0,d.c,d.d)),v))
if(w.gamL())C.d.iI(x,t.$1(!0),new A.Au(D.cX,u,new B.M(B.S(1/0,d.a,d.b),B.S(1/0,d.c,d.d)),v))
return x},
I(d){return new B.kq(new A.atq(this),null)}}
A.Qf.prototype={
aj(){return new A.W5(new B.bA(null,y.F))}}
A.W5.prototype={
azX(){switch(this.a.c.a){case 0:return C.k0
case 1:return C.cW
case 2:return C.fO
case 3:return C.e1}},
aAw(){switch(this.a.c.a){case 0:return new B.aB(0,0,8,0)
case 1:return new B.aB(0,0,0,8)
case 2:return new B.aB(8,0,0,0)
case 3:return new B.aB(0,8,0,0)}},
azZ(d){this.a.toString
return},
aQ(){this.bq()
$.co.x1$.push(this.ga57())},
bp(d){this.c9(d)
$.co.x1$.push(this.ga57())},
I(d){var x,w=this,v=null,u=w.a
u.toString
x=w.aAw()
return B.bm0(B.bm_(0,B.cq(w.azX(),u.e,C.p,v,v,v,v,v,w.d,x,v,v,v,v)),C.i)}}
A.aaB.prototype={
bx(d){return A.bGg(this.f,this.r,this.e)},
c3(d,e){var x=this.e
if(e.A!==x){e.A=x
e.af()}x=this.f
if(e.Y!==x){e.Y=x
e.af()}x=this.r
if(e.a3!==x){e.a3=x
e.af()}}}
A.Z5.prototype={
hX(d){if(!(d.b instanceof B.h1))d.b=new B.h1(null,null,C.i)},
iU(d){if(this.A===C.b3)return this.Eq(d)
return this.We(d)},
aA4(d){switch(this.A.a){case 0:return d.b
case 1:return d.a}},
a5p(d){switch(this.A.a){case 0:return d.a
case 1:return d.b}},
dX(d){var x=this.a3x(d,B.ic())
switch(this.A.a){case 0:return d.ca(new B.M(x.a,x.b))
case 1:return d.ca(new B.M(x.b,x.a))}},
a3x(d,e){var x,w,v,u,t,s,r,q,p=this,o=p.A===C.b3?d.b:d.d,n=p.am$
for(x=y.L,w=d.b,v=d.d,u=0,t=0;n!=null;){s=n.b
s.toString
x.a(s)
switch(p.A.a){case 0:r=B.fZ(v,null)
break
case 1:r=B.fZ(null,w)
break
default:r=null}q=e.$2(n,r)
t+=p.a5p(q)
u=Math.max(u,p.aA4(q))
n=s.aJ$}return new A.b5t(o<1/0?o:t,u)},
cK(){var x,w,v,u,t,s,r,q=this,p=y.k.a(B.J.prototype.ga5.call(q)),o=q.a3x(p,B.o7()),n=o.a,m=o.b
switch(q.A.a){case 0:q.fy=p.ca(new B.M(n,m))
q.gD(0)
q.gD(0)
break
case 1:q.fy=p.ca(new B.M(m,n))
q.gD(0)
q.gD(0)
break}x=q.am$
for(w=y.L,v=0;x!=null;){u=x.b
u.toString
w.a(u)
t=q.a3[v]
s=x.fy
r=t.b-q.a5p(s==null?B.V(B.Y("RenderBox was not laid out: "+B.G(x).j(0)+"#"+B.bW(x))):s)/2
switch(q.A.a){case 0:s=new B.q(r,0)
break
case 1:s=new B.q(0,r)
break
default:s=null}u.a=s
x=u.aJ$;++v}},
ex(d,e){return this.wi(d,e)},
bt(d,e){if(this.gD(0).ga6(0))return
this.ad.sbu(0,null)
this.qT(d,e)},
m(){this.ad.sbu(0,null)
this.aq2()}}
A.b5t.prototype={}
A.ats.prototype={}
A.m8.prototype={
gdf(){return[this.a,this.b]}}
A.n6.prototype={}
A.afi.prototype={}
A.afj.prototype={
aX(d){var x,w,v
this.fJ(d)
x=this.am$
for(w=y.L;x!=null;){x.aX(d)
v=x.b
v.toString
x=w.a(v).aJ$}},
aL(d){var x,w,v
this.fp(0)
x=this.am$
for(w=y.L;x!=null;){x.aL(0)
v=x.b
v.toString
x=w.a(v).aJ$}}}
A.afk.prototype={}
A.Sg.prototype={
m(){var x,w,v
for(x=this.WW$,w=x.length,v=0;v<w;++v)x[v].m()
this.iS()}}
A.Au.prototype={
gpp(){var x=this
switch(x.c.a){case 0:return x.d.d.b
case 1:return x.d.d.c
case 2:return x.d.d.d
case 3:return x.d.d.e}},
ghd(){switch(this.c.a){case 0:return C.fO
case 1:return C.e1
case 2:return C.k0
case 3:return C.cW}},
gb1Y(){var x=this.d,w=A.bk9(x.d),v=A.brt(x.a)
switch(this.c.a){case 2:case 0:return new B.aB(0,w.b,0,w.d).a4(0,new B.aB(0,v.b,0,v.d))
case 1:case 3:return new B.aB(w.a,0,w.c,0).a4(0,new B.aB(v.a,0,v.c,0))}},
gajb(){var x=this.d,w=A.brt(x.a),v=A.bk9(x.d)
switch(this.c.a){case 2:case 0:return v.ge6(0)+v.ged(0)+(w.ge6(0)+w.ged(0))
case 1:case 3:return v.gi8()+w.gi8()}},
aYS(d,e,f,g){var x,w,v,u,t,s=this,r=s.gpp().c.d
if(r==null)r=$.q_().P_(d,f-e)
x=$.bio()
w=s.c
w=w===D.k5||w===D.cX
v=s.d
u=x.aYe(w?v.w:v.z,r,f,e)
x=B.nu(u,new A.aTI(s,f,e,d),u.$ti.h("r.E"),y.V)
t=B.X(x,B.n(x).h("r.E"))
x=B.a9(t).h("ad<1,n6>")
x=B.X(new B.ad(t,new A.aTJ(s,e,f,r,g,d),x),x.h("aA.E"))
return x},
I(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k=this,j=null
k.gpp()
x=k.gpp()
x=x.c
x=!(x.a&&x.c!==0)
if(x)return B.cq(j,j,C.p,j,j,j,j,j,j,j,j,j,j,j)
x=k.c
w=x===D.k5
v=!w
u=!v||x===D.cX
t=k.e
s=u?t.a:t.b
u=k.ghd()
t=!v||x===D.cX?C.ar:C.b3
r=B.a([],y.p)
if(x===D.tg||w)k.gpp()
if(k.gpp().c.a){w=!v||x===D.cX?s:k.gpp().c.c
q=!v||x===D.cX?k.gpp().c.c:s
p=k.gb1Y()
o=!v||x===D.cX?C.b3:C.ar
k.gajb()
n=k.gajb()
m=!v||x===D.cX
l=k.d
m=m?l.f:l.x
v=!v||x===D.cX?l.r:l.y
r.push(B.cq(j,A.bOd(new A.ats(),o,k.aYS(s-n,m,v,x)),C.p,j,j,j,j,q,j,p,j,j,j,w))}if(x===D.th||x===D.cX)k.gpp()
return new B.ey(u,j,j,B.bJK(r,C.z,t,j,C.r,C.bk,0,j,j,C.ck),j)}}
A.Zj.prototype={
gdf(){return[this.a,this.b]}}
A.a2B.prototype={
gdf(){return[this.a,this.b]}}
A.LI.prototype={
gdf(){return[!0,this.b,this.c,this.d]}}
A.a2C.prototype={
gacI(d){return!1},
gdf(){return[!1,!1,!1,!1]}}
A.atU.prototype={}
A.aAq.prototype={
L(){return"FLHorizontalAlignment."+this.b}}
A.afs.prototype={}
A.ahY.prototype={}
A.ahZ.prototype={}
A.ai6.prototype={}
A.JC.prototype={
jr(d,e,f){}}
A.O8.prototype={}
A.hu.prototype={
gdw(){return null},
gaY_(){var x,w=this
B.bk()
B.bk()
B.bk()
x=w instanceof A.LH
if(x)return!0
return!(w instanceof A.LE)&&!(w instanceof A.LD)&&!(w instanceof A.LF)&&!(w instanceof A.LC)&&!x&&!(w instanceof A.LG)}}
A.a2G.prototype={
gdw(){return this.a.b}}
A.a2H.prototype={
gdw(){return this.a.b}}
A.a2I.prototype={
gdw(){return this.a.b}}
A.LD.prototype={}
A.LE.prototype={}
A.a2L.prototype={
gdw(){return this.a.b}}
A.LG.prototype={}
A.LH.prototype={
gdw(){return this.a.b}}
A.a2F.prototype={
gdw(){return this.a.b}}
A.a2E.prototype={
gdw(){return this.a.b}}
A.LC.prototype={
gdw(){return this.a.b}}
A.a2J.prototype={
gdw(){return this.a.gdw()}}
A.a2K.prototype={
gdw(){return this.a.gdw()}}
A.LF.prototype={
gdw(){return this.a.gdw()}}
A.FD.prototype={
ajx(d){this.Y=d.b
this.a3=d.c
this.ad=d.d},
aXs(){var x=this,w=null,v=x.aq=B.bl4(w,w)
v.ay=new A.aO2(x)
v.ch=new A.aO3(x)
v.CW=new A.aO4(x)
v.cy=new A.aO5(x)
v.cx=new A.aO6(x)
v=x.aV=B.QV(w,-1,w)
v.A=new A.aO7(x)
v.al=new A.aO8(x)
v.Y=new A.aO9(x)
v=x.c7=B.a59(w,x.ad,w)
v.p3=new A.aOa(x)
v.p4=new A.aOb(x)
v.RG=new A.aOc(x)},
cK(){var x=y.k.a(B.J.prototype.ga5.call(this))
this.fy=new B.M(x.b,x.d)},
dX(d){return new B.M(d.b,d.d)},
m0(d){return!0},
nt(d,e){var x,w=this
if(w.Y==null)return
if(y.l.b(d)){x=w.c7
x===$&&B.b()
x.w_(d)
x=w.aV
x===$&&B.b()
x.w_(d)
x=w.aq
x===$&&B.b()
x.w_(d)}else if(y.X.b(d))w.lL(new A.a2K(d))},
gNk(d){return new A.aOd(this)},
gNl(d){return new A.aOe(this)},
lL(d){var x,w,v,u=this
if(u.Y==null)return
x=d.gdw()
if(x!=null){w=u.gD(0)
v=new A.N4(u.jm.aWL(x,w,new A.O8(u.h3,u.lY,y.R)))}else v=null
u.Y.$2(d,v)
u.al=C.aR},
gLt(d){return this.al},
gGj(){var x=this.aD
x===$&&B.b()
return x},
aX(d){this.fJ(d)
this.aD=!0},
aL(d){this.aD=!1
this.fp(0)},
$ijy:1}
A.N1.prototype={
aj(){return new A.U6(B.a([],y.q),B.D(y.S,y.M),new A.aGr(B.D(y.r,y.Y)),null,null)}}
A.U6.prototype={
I(d){var x,w=this,v=w.a5b(),u=w.CW
u.toString
u=w.ach(u.aE(0,w.ghY().gt(0)))
x=w.ach(v)
w.a.toString
return new A.Z4(new A.a4Y(u,x,null),v,null)},
ach(d){var x=d.ch,w=B.a9(x).h("ad<1,ea>")
x=B.X(new B.ad(x,new A.b5A(this,d),w),w.h("aA.E"))
return d.aT1(x,this.cy)},
a5b(){var x,w,v,u,t=this,s=t.a.r,r=s.f,q=isNaN(r)
if(q||isNaN(s.r)||isNaN(s.x)||isNaN(s.y)){x=t.dx.aRc(s.ch)
if(q)r=x.a
q=s.r
if(isNaN(q))q=x.b
w=s.x
if(isNaN(w))w=x.c
v=s.y
s=s.aTc(q,isNaN(v)?x.d:v,r,w)}u=s.cx
t.cx=u.b
s=s.aSF(new A.N3(u.e,u.f,u.r,u.w,!0,u.y,u.z,!0,t.gaBf(),u.c,u.d))
return s},
aBg(d,e){var x,w=this
if(w.c==null)return
x=w.cx
if(x!=null)x.$2(d,e)
if(d.gaY_())x=(e==null?null:e.a)==null||e.a.length===0
else x=!0
if(x){w.V(new A.b5y(w))
return}w.V(new A.b5z(w,e))},
pD(d){var x=this
x.CW=y.aE.a(d.$3(x.CW,x.a5b(),new A.b5B(x)))}}
A.oX.prototype={
aYr(a0,a1,a2){var x,w,v,u,t,s,r,q,p,o,n,m,l,k=B.a8(a0.f,a1.f,a2),j=B.a8(a0.r,a1.r,a2),i=B.a8(a0.w,a1.w,a2),h=B.a8(a0.x,a1.x,a2),g=B.a8(a0.y,a1.y,a2),f=B.a8(a0.z,a1.z,a2),e=B.U(a0.as,a1.as,a2),d=a1.a
d=A.brs(B.au6(a0.a.b,d.b,a2),d.a)
x=a0.at
w=a1.at
v=A.pW(x.a,w.a,a2,A.bWr(),y.O)
v.toString
w=A.pW(x.b,w.b,a2,A.bWu(),y.Q)
w.toString
x=a0.c
u=a1.c
t=B.a8(x.c,u.c,a2)
x=B.a8(x.r,u.r,a2)
s=a0.d
r=a1.d
q=A.att(s.b,r.b,a2)
p=A.att(s.d,r.d,a2)
o=A.att(s.e,r.e,a2)
r=A.att(s.c,r.c,a2)
s=a0.e
n=a1.e
m=A.pW(s.a,n.a,a2,A.bWs(),y.B)
m.toString
n=A.pW(s.b,n.b,a2,A.bWv(),y.bc)
n.toString
s=A.pW(a0.ch,a1.ch,a2,A.bYS(),y.g)
s.toString
l=A.pW(a0.CW,a1.CW,a2,A.bYR(),y.J)
l.toString
o=A.bkK(e,i,f,l,d,a1.Q,new A.Lt(v,w,!0),new A.DP(u.a,!0,t,u.d,u.e,!0,x,u.w,u.x),s,a1.cx,j,g,k,h,new A.OM(m,n),a1.cy,new A.DQ(!0,q,r,p,o))
return o},
W2(d,e,f,g,h,i,j){var x=this,w=d==null?x.ch:d,v=e==null?x.cx:e,u=j==null?x.cy:j,t=h==null?x.f:h,s=f==null?x.r:f,r=i==null?x.x:i,q=g==null?x.y:g
return A.bkK(x.as,x.w,x.z,x.CW,x.a,x.Q,x.at,x.c,w,v,s,q,t,r,x.e,u,x.d)},
aTc(d,e,f,g){return this.W2(null,null,d,e,f,g,null)},
aSF(d){var x=null
return this.W2(x,d,x,x,x,x,x)},
aT1(d,e){var x=null
return this.W2(d,x,x,x,x,x,e)},
gdf(){var x=this
return[x.ch,x.CW,x.d,x.at,x.cx,x.cy,x.c,x.a,x.e,x.f,x.r,x.w,x.x,x.y,x.z,x.Q,x.as]}}
A.ea.prototype={
asG(d,e,f,g,h,i,j,k,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0){var x,w,v,u,t,s,r,q,p,o,n=this,m=null,l=null
try{l=C.d.Mi(n.a,new A.aGq())}catch(x){}if(l!=null){for(w=n.a,v=w.length,u=m,t=u,s=t,r=s,q=0;q<w.length;w.length===v||(0,B.F)(w),++q){p=w[q]
if(p!==D.bN)o=B.G(p)===B.G(D.bN)&&A.Y1(p.gdf(),D.bN.gdf())
else o=!0
if(o)continue
if(r==null||p.a<r.a)r=p
if(t==null||p.a>t.a)t=p
if(s==null||p.b>s.b)s=p
if(u==null||p.b<u.b)u=p}r.toString
n.b!==$&&B.aX()
n.b=r
s.toString
n.c!==$&&B.aX()
n.c=s
t.toString
n.d!==$&&B.aX()
n.d=t
u.toString
n.e!==$&&B.aX()
n.e=u}},
ae6(d,e){var x=this,w=e==null?x.a:e,v=d==null?x.cx:d
return A.bkJ(x.ch,x.x,x.ay,x.r,x.z,x.cy,x.CW,x.w,!0,!1,!0,!1,x.dy,!1,x.as,x.db,!0,v,w)},
aSM(d){return this.ae6(d,null)},
aSO(d){return this.ae6(null,d)},
gdf(){var x=this
return[x.a,!0,x.r,x.w,x.x,!0,x.z,!1,x.as,!0,!1,x.ay,x.ch,x.CW,x.cx,x.cy,x.db,!1,x.dy]}}
A.N2.prototype={
gdf(){return[this.a]}}
A.Ze.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d,x.e,!1]}}
A.m9.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d]}}
A.Jz.prototype={
gdf(){return[!1,this.b,this.c,!0]}}
A.ye.prototype={
gdf(){return[this.a,this.b,this.c]}}
A.a2D.prototype={
gdf(){return[!1,this.b,this.c,this.d]}}
A.N3.prototype={
gdf(){var x=this
return[!0,x.b,x.c,x.d,x.e,x.f,x.r,x.w,!0,x.y,x.z]}}
A.a4Z.prototype={
gdf(){return[D.o5,4,C.iL,16,D.vI,0,120,A.bYW(),!1,!1,!1,0,C.w]}}
A.oW.prototype={
gdf(){var x=this
return[x.c,x.d,x.e,x.a,x.b]}}
A.pC.prototype={}
A.r2.prototype={
gdf(){return[this.a,this.b,C.bd,C.l,null]}}
A.rU.prototype={
gdf(){return[this.a,this.b]}}
A.G5.prototype={
gdf(){return[this.a]}}
A.N4.prototype={}
A.yS.prototype={
hA(d){var x,w=this.a
w.toString
x=this.b
x.toString
return w.aYr(w,x,d)}}
A.afo.prototype={}
A.afp.prototype={}
A.aft.prototype={}
A.ai_.prototype={}
A.ai2.prototype={}
A.ajn.prototype={}
A.ajp.prototype={}
A.ajq.prototype={}
A.ajs.prototype={}
A.ajt.prototype={}
A.aju.prototype={}
A.ajv.prototype={}
A.anv.prototype={}
A.aoY.prototype={}
A.aGr.prototype={
aRc(d){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f
if(d.length===0)return D.pB
v=new A.N8(d,y.r)
u=this.a
if(u.az(0,v)){u=u.i(0,v)
t=u.a
s=u.b
r=u.c
u=u.d
return new A.yT(t,s,r,u,!0)}x=null
try{x=C.d.Mi(d,new A.aGs())}catch(q){return D.pB}w=null
try{w=C.d.Mi(x.a,new A.aGt())}catch(q){return D.pB}p=w.a
o=w.a
n=w.b
m=w.b
for(t=d.length,l=0;l<t;++l){k=d[l]
if(k.a.length===0)continue
s=k.d
s===$&&B.b()
j=s.a
if(j>o)o=j
s=k.b
s===$&&B.b()
i=s.a
if(i<p)p=i
s=k.c
s===$&&B.b()
h=s.b
if(h>m)m=h
s=k.e
s===$&&B.b()
g=s.b
if(g<n)n=g}f=new A.yT(p,o,n,m,!1)
u.l(0,v,f)
return f}}
A.yT.prototype={
gdf(){var x=this
return[x.a,x.b,x.c,x.d,x.e]}}
A.ajr.prototype={}
A.aGu.prototype={
jr(a1,a2,a3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=a3.a,a0=d.ch
if(a0.length===0)return
x=d.Q
if(x.gacI(0)){w=a2.b
v=w.a
w=w.b
$.ak()
u=a2.a
u.l2(new B.I(0,-40,0+(v+40),-40+(w+40)),B.ba())
u.a.clipRect(B.dF(new B.I(0,0,v,w)),$.ob()[1],!0)}e.anu(a1,a2,a3)
for(w=d.CW,v=w.length,t=0;t<w.length;w.length===v||(0,B.F)(w),++t)e.aUj(a2,d,w[t],a3)
s=B.a([],y.H)
for(w=d.cx,v=w.f,r=0;r<a0.length;++r){q=a0[r]
e.aUg(a2,q,a3)
e.aUk(a2,q,a3)
e.ant(a1,a2,a3)
u=q.cx
p=v.$2(q,u)
o=J.ag(p)
if(o.gp(p)!==u.length)throw B.d(B.ds("indicatorsData and touchedSpotOffsets size should be same"))
for(n=q.a,m=0;m<u.length;++m){l=o.i(p,m)
k=u[m]
if(k<0||k>=n.length)continue
j=n[k]
if(l==null)continue
s.push(new A.vk(q,j,k,l))}}e.aUr(a2,s,a3)
if(x.gacI(0))a2.a.a.restore()
for(a0=d.cy,w=w.e,x=y.b,r=0;r<a0.length;++r){i=a0[r].a
if(i.length===0)continue
h=B.X(i,x)
g=h[0]
for(v=h.length,t=0;t<v;++t){f=h[t]
if(f.b>g.b)g=f}e.aUq(a1,a2,w,g,new A.G5(h),a3)}},
aUg(d,e,f){var x,w,v,u,t,s,r,q=this,p=d.b,o=A.bk8(e.a)
for(x=o.length,w=0;w<o.length;o.length===x||(0,B.F)(o),++w){v=o[w]
u=q.ZS(p,e,v,f)
t=q.akm(p,e,u,v,f)
s=q.ZU(p,e,u,v,f,!0)
r=q.akl(p,e,u,v,f)
q.aUi(d,t,q.ZR(p,e,u,v,f,!0),f,e)
q.aUd(d,r,s,f,e)
q.aUh(d,u,e)
q.aUf(d,u,e,f)}},
aUj(a9,b0,b1,b2){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2=this,a3=a9.b,a4=b0.ch,a5=a4[b1.a],a6=a4[b1.b],a7=A.bk8(a5.a),a8=A.bk8(a6.a)
if(a7.length!==a8.length)throw B.d(B.aq("Cannot draw betWeenBarsArea when null spots are inconsistent.",null))
for(a4=a9.a,x=a4.a,w=b1.c,v=b1.d,u=$.bI.a,t=0+a3.a,s=0+a3.b,r=w==null,q=v!=null,p=0;p<a7.length;++p){o=a7[p]
n=a8[p]
m=B.a9(n).h("cr<1>")
l=B.X(new B.cr(n,m),m.h("aA.E"))
k=a2.ZS(a3,a5,o,b2)
j=a2.ZT(a3,a6.aSO(l),l,b2,k)
n=a5.b
n===$&&B.b()
m=a6.b
m===$&&B.b()
i=Math.min(n.a,m.a)
m=a5.c
m===$&&B.b()
n=a6.c
n===$&&B.b()
h=Math.max(m.b,n.b)
n=a5.d
n===$&&B.b()
m=a6.d
m===$&&B.b()
g=Math.max(n.a,m.a)
m=a5.e
m===$&&B.b()
n=a6.e
n===$&&B.b()
f=Math.min(m.b,n.b)
n=a2.f9(i,a3,b2)
m=a2.hF(h,a3,b2)
e=a2.f9(g,a3,b2)
d=a2.hF(f,a3,b2)
a0=a2.r
a0===$&&B.b()
if(q){a0.r=C.o.gt(0)
a0.sfb(v.px(0,new B.I(n,m,e,d)))}else{a0.r=(r?C.y:w).gt(0)
a0.sfb(null)}$.ak()
a1=new B.ot(C.cF,C.bm,C.fB,C.ex,C.dh).h5()
n=B.dF(new B.I(0,0,t,s))
m=$.bI.b
if(m===$.bI)B.V(B.vi(u))
m=m.TileMode.Clamp
x.saveLayer.apply(x,[a1,n,null,null,m])
a1.delete()
a4.iV(j,a2.r)
x.restore()}},
aUk(d,e,f){var x,w,v,u,t,s,r,q,p,o,n=e.CW
if(!n.a||e.a.length===0)return
x=d.b
w=this.ZX(e,x,f)
for(v=e.a,u=n.b,n=n.c,t=d.a,s=0;s<v.length;++s){r=v[s]
if(r!==D.bN)q=B.G(r)===B.G(D.bN)&&A.Y1(r.gdf(),D.bN.gdf())
else q=!0
if(!q&&u.$2(r,e)){p=this.f9(r.a,x,f)
o=this.hF(r.b,x,f)
n.$4(r,p/w*100,e,s).aeJ(t,r,new B.q(p,o))}}},
aUr(b1,b2,b3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this
if(b2.length===0)return
x=b1.b
C.d.fc(b2,new A.aGx())
for(w=b2.length,v=b3.a,u=b1.a,t=v.y,s=v.x,r=v.cx,q=r.y,r=r.z,p=0;p<b2.length;b2.length===w||(0,B.F)(b2),++p){o=b2[p]
n=o.a
m=b0.ZX(n,x,b3)
l=o.d
k=o.c
j=o.e
i=b0.f9(k.a,x,b3)
h=b0.hF(k.b,x,b3)
g=j.b
f=g.a
e=B.bM()
if(f){g=e.b=g.c.$4(k,i/m*100,n,l)
if(g===e)B.V(B.np(e.a))
d=g.b*2}else d=0
a0=Math.min(t,Math.max(s,B.k3(q.$2(n,l))))
a1=Math.min(t,Math.max(s,B.k3(r.$2(n,l))))
g=b0.hF(a0,x,b3)
a2=new B.q(i,g)
a3=b0.hF(a1,x,b3)
a4=new B.q(i,a3)
a5=d/2
a6=h-a5
a7=h+a5
if(a3>a6&&a3<a7)a4=g<a3?new B.q(i,a3-(a3-a6)):new B.q(i+0,a3+(a7-a3))
a8=j.a
g=b0.y
g===$&&B.b()
a3=a8.a
a5=a8.b
a9=B.kw(a2,a4)
if(a5!=null){g.r=C.o.gt(0)
g.sfb(a5.px(0,a9))}else{if(a3==null)a3=C.y
g.r=a3.gt(a3)
g.sfb(null)}a3=a8.c
g.c=a3
if(a3===0){g.sfb(null)
a3=B.bV(g.r)
g.r=B.aR(0,a3.F()>>>16&255,a3.F()>>>8&255,a3.F()&255).gt(0)}b1.EA(a2,a4,b0.y,a8.d)
if(f){g=e.b
if(g===e)B.V(B.np(e.a))
g.aeJ(u,k,new B.q(i,h))}}},
ZT(d,e,f,g,h){var x=this.akn(d,e,f,g,h)
return x},
ZS(d,e,f,g){return this.ZT(d,e,f,g,null)},
akn(d,e,a0,a1,a2){var x,w,v,u,t,s,r,q,p,o,n,m,l=this,k=a2==null,j=k?B.cP($.ak().r):a2,i=J.ag(a0),h=i.gp(a0),g=l.f9(i.i(a0,0).a,d,a1),f=l.hF(i.i(a0,0).b,d,a1)
if(k){j.aO(new B.hU(g,f))
if(h===1)j.aO(new B.cX(g,f))}else j.aO(new B.cX(g,f))
for(k=j.e,x=e.z,w=C.i,v=1;v<h;v=q,w=m){u=l.f9(i.i(a0,v).a,d,a1)
t=l.hF(i.i(a0,v).b,d,a1)
s=v-1
r=l.f9(i.i(a0,s).a,d,a1)
s=l.hF(i.i(a0,s).b,d,a1)
q=v+1
p=q<h
o=l.f9(i.i(a0,p?q:v).a,d,a1)
n=l.hF(i.i(a0,p?q:v).b,d,a1)
p=(o-r)/2*x
n=(n-s)/2*x
m=new B.q(p,n)
u=new B.Kp(r+w.a,s+w.b,u-p,t-n,u,t)
k.push(u)
t=j.d
if(t!=null)u.je(t)}return j},
ZU(d,e,f,g,h,i){var x,w,v,u,t=this
$.ak()
x=B.bkH(f)
w=J.ag(g)
v=t.f9(w.i(g,w.gp(g)-1).a,d,h)
u=d.b
x.aO(new B.cX(v,u))
v=t.f9(w.i(g,0).a,d,h)
x.aO(new B.cX(v,u))
x.aO(new B.cX(t.f9(w.i(g,0).a,d,h),t.hF(w.i(g,0).b,d,h)))
x.aO(new B.qf())
return x},
akm(d,e,f,g,h){return this.ZU(d,e,f,g,h,!1)},
ZR(d,e,f,g,h,i){var x,w,v,u=this
$.ak()
x=B.bkH(f)
w=J.ag(g)
v=u.f9(w.i(g,w.gp(g)-1).a,d,h)
x.aO(new B.cX(v,0))
v=u.f9(w.i(g,0).a,d,h)
x.aO(new B.cX(v,0))
x.aO(new B.cX(u.f9(w.i(g,0).a,d,h),u.hF(w.i(g,0).b,d,h)))
x.aO(new B.qf())
return x},
akl(d,e,f,g,h){return this.ZR(d,e,f,g,h,!1)},
aUi(d,e,f,g,h){var x,w,v,u,t,s=this,r=h.ay
if(!r.a)return
x=d.b
w=h.b
w===$&&B.b()
w=s.f9(w.a,x,g)
v=h.c
v===$&&B.b()
v=s.hF(v.b,x,g)
u=h.d
u===$&&B.b()
u=s.f9(u.a,x,g)
t=s.r
t===$&&B.b()
A.bl3(t,r.b,r.c,new B.I(w,v,u,x.b))
d.a.iV(e,s.r)},
aUd(d,e,f,g,h){var x,w,v,u,t,s=this,r=h.ch
if(!r.a)return
x=d.b
w=h.b
w===$&&B.b()
w=s.f9(w.a,x,g)
v=h.d
v===$&&B.b()
v=s.f9(v.a,x,g)
u=h.e
u===$&&B.b()
u=s.hF(u.b,x,g)
t=s.r
t===$&&B.b()
A.bl3(t,r.b,r.c,new B.I(w,0,v,u))
d.a.iV(e,s.r)},
aUh(d,e,f){var x=f.db,w=x.a,v=w.F()
if((v>>>24&255)/255===0)return
if(!new B.MX(e,!1,B.a([],y.A)).u())return
v=this.f
v===$&&B.b()
v.d=C.jG
v.e=C.ex
v.r=w.gt(0)
v.sfb(null)
v.c=f.x
v.r=w.gt(0)
$.q_()
v.z=new B.yZ(C.e4,x.c*0.57735+0.5)
d.a.iV(B.bkI(A.bjB(e,f.cy),x.b),this.f)},
aUf(d,e,f,g){var x,w,v,u,t=this,s=d.b,r=t.f
r===$&&B.b()
r.d=C.jG
r.e=C.ex
r=f.b
r===$&&B.b()
r=t.f9(r.a,s,g)
x=f.c
x===$&&B.b()
x=t.hF(x.b,s,g)
w=f.d
w===$&&B.b()
w=t.f9(w.a,s,g)
v=f.e
v===$&&B.b()
v=t.hF(v.b,s,g)
u=t.f
A.bl3(u,f.r,f.w,new B.I(r,x,w,v))
u.z=null
u.c=f.x
A.bMk(u)
d.a.iV(A.bjB(e,f.cy),t.f)},
aUq(b1,b2,b3,b4,b5,b6){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4=this,a5=null,a6=b2.b,a7=B.a([],y.u),a8=b5.a,a9=A.byq(a8),b0=J.ag(a9)
if(b0.gp(a9)!==a8.length)throw B.d(B.ds("tooltipItems and touchedSpots size should be same"))
for(x=b6.c,w=0;w<a8.length;++w){v=b0.i(a9,w)
if(v==null)continue
u=$.q_().ale(b1,v.b)
t=v.a
s=x.k(0,C.h_)?new B.jY(1):x
r=new B.rS(new B.hE(t,a5,a5,C.aR,a5,a5,a5,a5,a5,a5,u),C.bd,C.l,s,a5,a5,a5,a5,C.b9,a5)
r.aYn(120)
a7.push(r)}a8=a7.length
if(a8===0)return
for(q=0,p=0,o=0;b0=a7.length,o<b0;a7.length===a8||(0,B.F)(a7),++o){b0=a7[o].b
n=b0.c
if(n>q)q=n
b0=b0.a.c
p+=b0.gaH(b0)}a8=a4.f9(b4.a,a6,b6)
x=a4.hF(b4.b,a6,b6)
m=q+C.iL.gi8()
l=p+(b0-1)*4+(C.iL.ge6(0)+C.iL.ged(0))
k=x-l-16
j=a4.alf(a8,m,D.vI,0)
a8=j+m
b0=k+l
i=new B.b3(4,4)
h=B.aNe(new B.I(j,k,a8,b0),i,i,i,i)
x=a4.z
x===$&&B.b()
x.r=D.o5.gt(0)
x=a8-j
b0-=k
u=$.q_().adp(new B.M(x,b0),0).b
g=new B.q(0,u)
f=new B.q(h.a,h.b)
e=$.q_().adp(new B.M(x,b0),0)
if(!C.w.k(0,C.w)){t=a4.Q
t===$&&B.b()
t.r=C.o.gt(0)
t.c=0}b2.aeO(0,new A.aGv(a4,b2,h),f,g,new B.M(x,b0))
for(t=a7.length,s=j+x/2,d=e.b,a8-=16,a0=j+16,a1=8,o=0;o<a7.length;a7.length===t||(0,B.F)(a7),++o){r=a7[o]
a2=A.bOM(r.r,r.w)
A:{if(D.vX===a2){a3=a0
break A}if(D.vY===a2){a3=a8-r.b.c
break A}a3=s-r.b.c/2
break A}b2.aeO(0,new A.aGw(b2,r,new B.q(a3,k+a1-d+u)),f,g,new B.M(x,b0))
a3=r.b.a.c
a1=a1+a3.gaH(a3)+4}},
ZX(d,e,f){var x,w=d.a
if(w.length===0)return 0
x=this.f9(w[0].a,e,f)
return this.f9(w[w.length-1].a,e,f)-x},
aWL(d,e,f){var x,w,v,u=B.a([],y.a)
for(x=f.a.ch,w=0;w<x.length;++w){v=this.akY(e,d,x[w],w,f)
if(v!=null)u.push(v)}C.d.fc(u,new A.aGy())
return u.length===0?null:u},
akY(d,e,f,g,h){var x,w,v,u,t,s,r,q,p,o=B.a([],y.U)
for(x=f.a,w=x.length,v=h.a.cx,u=v.r,v=v.w,t=null,s=0;s<x.length;x.length===w||(0,B.F)(x),++s){r=x[s]
if(r!==D.bN)q=B.G(r)===B.G(D.bN)&&A.Y1(r.gdf(),D.bN.gdf())
else q=!0
if(q)continue
p=v.$2(e,new B.q(this.f9(r.a,d,h),this.hF(r.b,d,h)))
if(p<=u){if(t==null)t=p
if(p<t){C.d.iI(o,0,r)
t=p}else o.push(r)}}if(o.length!==0){w=C.d.ga0(o)
t.toString
return new A.pC(t,f,g,C.d.fB(x,w),w.a,w.b)}else return null}}
A.vk.prototype={}
A.a4Y.prototype={
bx(d){var x,w=this.e,v=B.bz(d,null,y.w).w.gdD(),u=new A.aGu()
u.as9()
$.ak()
x=B.ba()
x.b=C.b8
u.f=x
x=B.ba()
x.b=C.bm
u.r=x
x=B.ba()
x.b=C.b8
u.w=x
x=B.ba()
x.b=C.bm
x.r=C.y.gt(0)
x.a=D.Pp
u.x=x
x=B.ba()
x.b=C.b8
x.r=C.o.gt(0)
u.y=x
x=B.ba()
x.b=C.bm
x.r=C.j.gt(0)
u.z=x
x=B.ba()
x.b=C.b8
x.r=C.y.gt(0)
x.c=1
u.Q=x
u=new A.a9j(this.d,w,v,u,d,C.aR,new B.bq(),B.aL(y.v))
u.bw()
u.ajx(w.cx)
u.aXs()
return u},
c3(d,e){e.smA(0,this.d)
e.sb1R(this.e)
e.sdD(B.bz(d,null,y.w).w.gdD())
e.A=d
e.bn()}}
A.a9j.prototype={
smA(d,e){if(this.h3.k(0,e))return
this.h3=e
this.bn()},
sb1R(d){var x=this
if(x.oy.k(0,d))return
x.oy=d
x.aoK(d.cx)
x.bn()},
sdD(d){if(this.lY.k(0,d))return
this.lY=d
this.bn()},
bt(d,e){var x,w,v=this,u=d.geo(0),t=u.a
J.aQ(t.save())
t.translate(e.a,e.b)
x=v.A
w=v.gD(0)
v.jm.jr(x,new A.av1(u,w),new A.O8(v.h3,v.lY,y.R))
t.restore()}}
A.M8.prototype={
L(){return"HorizontalAlignment."+this.b}}
A.av1.prototype={
aUp(d,e){d.bt(this.a,e)},
aeO(d,e,f,g,h){var x,w,v,u,t=this.a,s=t.a
J.aQ(s.save())
x=f.a
w=h.a/2
v=f.b
u=h.b/2
s.translate(g.a+x+w,g.b+v+u)
$.q_()
t.Za(0,d*0.017453292519943295)
s.translate(-x-w,-v-u)
e.$0()
s.restore()},
EA(d,e,f,g){var x=B.cP($.ak().r)
x.aO(new B.hU(d.a,d.b))
x.aO(new B.cX(e.a,e.b))
this.a.iV(A.bjB(x,g),f)}}
A.N8.prototype={
gdf(){return[this.a]}}
A.ajB.prototype={}
A.ZS.prototype={}
A.aXb.prototype={
adp(d,e){var x=d.a,w=e*0.017453292519943295,v=Math.sin(w),u=d.b,t=Math.cos(w)
return new B.q((x-(Math.abs(x*Math.cos(w))+Math.abs(u*Math.sin(w))))/2,(u-(Math.abs(x*v)+Math.abs(u*t)))/2)},
P_(d,e){var x,w=Math.max(C.c.aC(d,40),1)
if(e===0)return 1
x=e/w
if(w<=2)return x
return this.b1L(x)},
b1L(d){if(d<1)return this.aLv(d)
return this.a98(d)},
aLv(d){var x,w,v,u,t,s,r
if(d<0.000001)return d
x=C.c.j(d)
w=x.length
v=w-2
for(u=0,t=2;t<=w;++t){if(x[t]!=="0")break;++u}s=v-u
if(s>2)v-=s-2
r=Math.pow(10,v)
return this.a98(d*r)/r},
a98(d){var x,w=C.b.j(C.c.B(d)).length-1
d/=Math.pow(10,w)
x=d>=10?C.c.b1(d)/10:d
if(x>=7.6)return 10*C.c.B(Math.pow(10,w))
else if(x>=2.6)return 5*C.c.B(Math.pow(10,w))
else if(x>=1.6)return 2*C.c.B(Math.pow(10,w))
else return C.c.B(Math.pow(10,w))},
akK(d){if(d>=1)return 1
else if(d>=0.1)return 2
else if(d>=0.01)return 3
else if(d>=0.001)return 4
else if(d>=0.0001)return 5
else if(d>=0.00001)return 6
else if(d>=0.000001)return 7
else if(d>=1e-7)return 8
else if(d>=1e-8)return 9
else if(d>=1e-9)return 10
return 1},
ale(d,e){var x,w,v=d.ap(y._)
if(v==null)v=C.kK
x=e.a?v.w.c8(e):e
w=B.c6(d,C.nm)
w=w==null?null:w.ay
return w===!0?x.c8(C.dX):x},
akA(d,e,f,g){var x=C.c.P(g-d,f)
if(Math.abs(e-d)<=x)return d
if(x===0)return d
return d+x}}
A.BO.prototype={
L(){return"_TimeFilter."+this.b}}
A.abj.prototype={
I(d){return D.akE}}
A.anT.prototype={
I(d){var x=null
return B.oj(x,x,x,!0,!0,x,x,1,x,x,x,!1,x,!1,x,x,x,x,!0,x,x,x,x,x,B.aa(B.aG(B.ci(d,!0,y.f).r,"stat_title",x),x,x,x,x,x,x,x),x,x,x,1,x,!0)},
gAz(){return E.mT}}
A.Wi.prototype={
aj(){return new A.anU(D.t8)}}
A.anU.prototype={
I(d){var x=this,w=B.ci(d,!0,y.P),v=B.ci(d,!0,y.c).gD7(),u=B.ci(d,!0,y.f).r,t=new B.bE(Date.now(),0,!1),s=w.c,r=y.d,q=x.auF(B.hT(s,r),t,u),p=x.av2(B.hT(s,r),t),o=C.d.hM(p,0,new A.bco(),y.i)
return B.pr(B.ce(B.a([new A.Tu(x.d,new A.bcp(x),null),E.mW,new A.Sz(q,null),E.mW,new A.WD(p,o,v.gck(),null)],y.p),C.ak,C.r,C.u),C.bu)},
auF(d,e,a0){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f
switch(this.d.a){case 0:x=B.cH(B.b9(e),B.br(e),B.cI(e),0,0,0,0)
w=x.vu(-5184e8)
v=J.dB(7,y.h)
for(u=0;u<7;++u)v[u]=new A.lT(B.ke("E",a0).ea(w.vu(864e8*u)),0)
for(t=d.length,s=w.a,r=w.b,q=x.a,p=x.b,o=0;o<t;++o){n=d[o]
m=n.d
if(m>=0)continue
l=n.c
k=B.cH(B.b9(l),B.br(l),B.cI(l),0,0,0,0)
l=k.a
if(l>=s)j=l===s&&k.b<r
else j=!0
i=!0
if(!j)if(l<=q)j=l===q&&k.b>p
else j=i
else j=i
if(j)continue
h=C.b.aC(k.b-r+1000*(l-s),864e8)
l=v[h]
v[h]=new A.lT(l.a,l.b+Math.abs(m))}return v
case 1:g=B.cI(B.cH(B.b9(e),B.br(e)+1,0,0,0,0,0))
v=J.dB(g,y.h)
for(u=0;u<g;u=f){f=u+1
v[u]=new A.lT(""+f,0)}for(t=d.length,o=0;o<t;++o){n=d[o]
s=n.d
if(s>=0)continue
r=n.c
if(B.b9(r)!==B.b9(e)||B.br(r)!==B.br(e))continue
h=B.cI(r)-1
r=v[h]
v[h]=new A.lT(r.a,r.b+Math.abs(s))}return v
case 2:v=J.dB(12,y.h)
for(u=0;u<12;u=f){f=u+1
v[u]=new A.lT(B.ke("MMM",a0).ea(B.cH(B.b9(e),f,1,0,0,0,0)),0)}for(t=d.length,o=0;o<t;++o){n=d[o]
s=n.d
if(s>=0)continue
r=n.c
if(B.b9(r)!==B.b9(e))continue
h=B.br(r)-1
r=v[h]
v[h]=new A.lT(r.a,r.b+Math.abs(s))}return v}},
av2(d,e){var x,w,v,u,t,s,r,q=B.D(y.o,y.i)
for(x=d.length,w=0;w<x;++w){v=d[w]
u=v.d
if(u>=0)continue
if(!this.aFk(v.c,e))continue
t=C.e.cu(v.b)
if(t.length===0)t="Other"
s=q.i(0,t)
if(s==null)s=0
q.l(0,t,s+Math.abs(u))}x=q.$ti.h("eD<1,2>")
x=B.nu(new B.eD(q,x),new A.bcl(),x.h("r.E"),y.be)
r=B.X(x,B.n(x).h("r.E"))
C.d.fc(r,new A.bcm())
return r},
aFk(d,e){var x,w,v
switch(this.d.a){case 0:x=B.cH(B.b9(e),B.br(e),B.cI(e),0,0,0,0)
w=x.vu(-5184e8)
v=B.cH(B.b9(d),B.br(d),B.cI(d),0,0,0,0)
return!v.wQ(w)&&!v.kO(x)
case 1:return B.b9(d)===B.b9(e)&&B.br(d)===B.br(e)
case 2:return B.b9(d)===B.b9(e)}}}
A.Tu.prototype={
aj(){return new A.ahS()},
rr(d){return this.d.$1(d)}}
A.ahS.prototype={
I(d){var x=this,w=null,v=B.ci(d,!0,y.f).r
return B.dJ(B.a([B.ef(new A.Bi(B.aG(v,"stat_weekly",w),x.a.c===D.P_,new A.b2r(x),w),1),C.mU,B.ef(new A.Bi(B.aG(v,"stat_monthly",w),x.a.c===D.t8,new A.b2s(x),w),1),C.mU,B.ef(new A.Bi(B.aG(v,"stat_yearly",w),x.a.c===D.P0,new A.b2t(x),w),1)],y.p),C.z,C.r,C.u,0)}}
A.Bi.prototype={
aj(){return new A.ahT()},
gd_(d){return this.c}}
A.ahT.prototype={
I(d){var x,w,v,u=null,t=B.W(d).ax.a===C.R,s=this.a,r=s.e,q=B.c8(20)
if(s.d)s=C.ae
else s=t?B.W(d).at:C.j
x=B.c8(20)
w=this.a
v=w.c
if(w.d)w=C.j
else w=t?C.a0:C.je
return B.qX(!1,q,!0,B.cq(C.a4,B.aa(v,u,u,u,B.cb(u,u,w,u,u,u,u,u,u,u,u,u,u,u,C.Z,u,u,!0,u,u,u,u,u,u,u,u),u,u,u),C.p,u,u,new B.cv(s,u,u,x,u,u,C.Y),u,u,u,u,D.W2,u,u,u),u,!0,u,u,u,u,u,u,u,u,u,u,r,u,u,u,u)}}
A.Sz.prototype={
aj(){return new A.afT()}}
A.afT.prototype={
I(d){var x=null,w=B.W(d)
return B.ce(B.a([D.asK,C.dB,B.dt(C.d.hh(this.a.c,new A.b_K())?B.dR(B.aa("No expense data in selected range",x,x,x,B.cb(x,x,w.ax.k3.j5(0.8),x,x,x,x,x,x,x,x,x,x,x,x,x,x,!0,x,x,x,x,x,x,x,x),x,x,x),x,x):new B.kx(new A.N1(this.aGf(this.a.c),C.ai,C.f0,x,x),x),250,x)],y.p),C.ak,C.r,C.u)},
aGf(d){var x,w=null,v=C.d.hM(d,0,new A.b_I(),y.i),u=v<=0?10:v*1.2,t=A.brs(w,!1),s=d.length,r=this.aNY(s),q=J.dB(s,y.D)
for(x=0;x<s;++x)q[x]=new A.eP(x,d[x].b)
s=d.length
return A.bkK(w,w,w,D.a9q,t,D.Qp,D.WS,D.X4,B.a([A.bkJ(w,4,A.bjf(!1,C.ae.j5(0.12),0,w,!0,D.tl),C.ae,0.35,w,new A.ye(s<=12,A.bnH(),A.byP()),w,!0,!1,!0,!1,D.Zr,!1,10,D.alC,!0,C.pN,q)],y.n),D.Zs,w,u,w,0,D.ajU,D.a9r,new A.DQ(!0,D.nQ,D.nQ,D.nQ,new A.tC(16,w,new A.w9(!0,new A.b_J(d),24,r),!0)))},
aNY(d){if(d<=8)return 1
if(d<=16)return 2
if(d<=24)return 3
return 5}}
A.WD.prototype={
aj(){return new A.aoV()},
aVy(d){return this.e.$1(d)}}
A.aoV.prototype={
I(d){var x,w=null,v=B.W(d),u=B.ci(d,!0,y.f).r,t=B.a([B.aa(B.aG(u,"stat_top_spending",w),w,w,w,F.n0,w,w,w),F.r5],y.p)
if(this.a.c.length===0){v=v.ax.a===C.R?B.W(d).at:C.j
x=B.c8(16)
t.push(B.cq(w,B.aa(B.aG(u,"stat_no_spending",w),w,w,w,w,w,w,w),C.p,w,w,new B.cv(v,w,w,x,w,w,C.Y),w,w,w,w,C.f2,w,w,1/0))}v=this.a.c
v=B.f4(v,0,B.iL(5,"count",y.S),B.a9(v).c)
C.d.S(t,new B.ad(v,new A.bdI(this,u),v.$ti.h("ad<aA.E,i>")))
return B.ce(t,C.ak,C.r,C.u)},
aw_(d){var x=new B.dM(d)
return D.a0Y[C.b.P(x.hM(x,0,new A.bdH(),y.S),6)]}}
A.B8.prototype={
aj(){return new A.afR()},
gd_(d){return this.c},
gpn(){return this.d}}
A.afR.prototype={
I(d){var x,w,v,u=null,t=B.W(d).ax.a===C.R?B.W(d).at:C.j,s=B.c8(16),r=this.a,q=y.p
r=B.dJ(B.a([B.ef(B.aa(r.c,u,C.b0,u,D.ap4,u,u,u),1),C.hN,B.aa(r.d,u,u,u,C.dX,u,u,u)],q),C.z,C.dx,C.u,0)
x=this.a
w=x.e
x=x.f.j5(0.15)
v=this.a.f
return B.cq(u,B.ce(B.a([r,C.d9,G.bsQ(x,B.c8(10),8,w,new B.xc(v,y.K))],q),C.z,C.r,C.u),C.p,u,u,new B.cv(t,u,u,s,u,u,C.Y),u,u,u,D.W0,D.Wh,u,u,u)}}
A.lT.prototype={}
A.kN.prototype={
gd_(d){return this.a},
gpn(){return this.b}}
var z=a.updateTypes(["K(eP)","N(ea,m)","m(pC,pC)","m(vk,vk)","n6(m8)","~(hu,N4?)","ea(ea)","m8(n6)","yS(@)","i(n6)","rU(m)","uK(eP,N,ea,m)","r2(oW)","K(ea)","~(@)","N(N,kN)","~(BO)","kN(bj<j,N>)","m(kN,kN)","K(lT)","N(N,lT)","bQ(N,AL)","B8(kN)","m(m,A?)","i(N,AL)","eP(eP,eP,N)","K(N)","qG(N)","m(m,m,N)","mG(mG,mG,N)","km(km,km,N)","kI(kI,kI,N)","j(km)","j(kI)","ea(ea,ea,N)","m9(m9,m9,N)","uK(eP,N,ea,m{size:N?})","K(eP,ea)","N(q,q)","B<rU>(ea,B<m>)","m8(N)","B<r2>(B<oW>)","mh(mh,mh,N)"])
A.bi7.prototype={
$1(d){return A.bnN(this.a,d)},
$S:24}
A.bf4.prototype={
$2(d,e){return J.P(d)-J.P(e)},
$S:295}
A.bf5.prototype={
$1(d){var x=this.a,w=x.a,v=x.b
v.toString
x.a=(w^A.bmV(w,[d,J.p(y.G.a(v),d)]))>>>0},
$S:8}
A.bf6.prototype={
$2(d,e){return J.P(d)-J.P(e)},
$S:295}
A.bhN.prototype={
$1(d){return J.dd(d)},
$S:130}
A.atr.prototype={
$1(d){return 0},
$S:970}
A.atq.prototype={
$2(d,e){return B.jK(C.cl,this.a.anc(e),C.E,C.ch)},
$S:971}
A.aTG.prototype={
$1(d){return d.a},
$S:z+7}
A.aTH.prototype={
$1(d){return d.b},
$S:z+9}
A.aTI.prototype={
$1(d){var x=this,w=x.c,v=x.b-w,u=v>0?(d-w)/v:0
w=x.a.c
if(!(w===D.k5||w===D.cX))u=1-u
return new A.m8(d,u*x.d)},
$S:z+40}
A.aTJ.prototype={
$1(d){var x,w,v,u,t=this,s=t.a,r=s.gpp(),q=d.a
s.gpp()
s=$.q_()
x=q<0
w=x?Math.abs(q):q
if(w>=1e9){v=C.c.aB(w/1e9,1)
u="B"}else if(w>=1e6){v=C.c.aB(w/1e6,1)
u="M"}else if(w>=1000){v=C.c.aB(w/1000,1)
u="K"}else{v=C.c.aB(w,s.akK(Math.abs(t.b-t.c)))
u=""}if(C.e.i5(v,".0"))v=C.e.a1(v,0,v.length-2)
if(x)v="-"+v
if(v==="-0")v="0"
return new A.n6(d,r.c.b.$2(q,new A.AL(v+u,t.e)))},
$S:z+4}
A.aO2.prototype={
$1(d){this.a.lL(new A.a2G(d))},
$S:146}
A.aO3.prototype={
$1(d){this.a.lL(new A.a2H(d))},
$S:37}
A.aO4.prototype={
$1(d){this.a.lL(new A.a2I(d))},
$S:19}
A.aO5.prototype={
$0(){this.a.lL(D.Qq)},
$S:0}
A.aO6.prototype={
$1(d){this.a.lL(new A.LE())},
$S:38}
A.aO7.prototype={
$1(d){this.a.lL(new A.a2L(d))},
$S:42}
A.aO8.prototype={
$0(){this.a.lL(D.Qr)},
$S:0}
A.aO9.prototype={
$1(d){this.a.lL(new A.LH(d))},
$S:85}
A.aOa.prototype={
$1(d){this.a.lL(new A.a2F(d))},
$S:151}
A.aOb.prototype={
$1(d){this.a.lL(new A.a2E(d))},
$S:152}
A.aOc.prototype={
$1(d){return this.a.lL(new A.LC(d))},
$S:153}
A.aOd.prototype={
$1(d){return this.a.lL(new A.a2J(d))},
$S:53}
A.aOe.prototype={
$1(d){return this.a.lL(new A.LF(d))},
$S:48}
A.b5A.prototype={
$1(d){var x=this.a.db.i(0,C.d.fB(this.b.ch,d))
return d.aSM(x==null?B.a([],y.t):x)},
$S:z+6}
A.b5y.prototype={
$0(){var x=this.a
C.d.T(x.cy)
x.db.T(0)},
$S:0}
A.b5z.prototype={
$0(){var x,w,v,u,t,s,r=this.b.a
r.toString
x=B.X(r,y.y)
C.d.fc(x,new A.b5x())
w=this.a
v=w.db
v.T(0)
for(u=y.t,t=0;t<r.length;++t){s=r[t]
v.l(0,s.d,B.a([s.e],u))}r=w.cy
C.d.T(r)
r.push(new A.G5(x))},
$S:0}
A.b5x.prototype={
$2(d,e){return C.c.be(e.b,d.b)},
$S:z+2}
A.b5B.prototype={
$1(d){return new A.yS(y.e.a(d),this.a.a.r)},
$S:z+8}
A.aGq.prototype={
$1(d){return!d.k(0,D.bN)},
$S:z+0}
A.bgR.prototype={
$1(d){var x,w={},v=this.a,u=v.w,t=u==null?null:C.d.ga0(u.a)
if(t==null)t=v.r
u=v.CW.a
x=A.bru(u?A.bmZ(v.a[d],0,v):t,null,null,4)
w.a=10
if(u)w.a=7.2
return new A.rU(x,new A.ye(!0,A.bnH(),new A.bgQ(w)))},
$S:z+10}
A.bgQ.prototype={
$4(d,e,f,g){var x=this.a.a
return A.bJI(A.bmZ(d,e,f),x,A.bTE(d,e,f))},
$C:"$4",
$R:4,
$S:z+11}
A.bgO.prototype={
$1(d){var x,w=null,v=d.c,u=v.w
u=u==null?w:C.d.ga0(u.a)
v=u==null?v.r:u
x=B.cb(w,w,v==null?D.d7:v,w,w,w,w,w,w,w,w,14,w,w,C.Z,w,w,!0,w,w,w,w,w,w,w,w)
return new A.r2(C.c.j(d.b),x)},
$S:z+12}
A.aGs.prototype={
$1(d){return d.a.length!==0},
$S:z+13}
A.aGt.prototype={
$1(d){return!d.k(0,D.bN)},
$S:z+0}
A.aGx.prototype={
$2(d,e){return C.c.be(e.c.b,d.c.b)},
$S:z+3}
A.aGv.prototype={
$0(){var x,w=this.c,v=this.a,u=v.z
u===$&&B.b()
x=this.b.a
x.fL(w,u)
v=v.Q
v===$&&B.b()
x.fL(w,v)},
$S:0}
A.aGw.prototype={
$0(){this.a.aUp(this.b,this.c)},
$S:0}
A.aGy.prototype={
$2(d,e){return C.c.be(d.w,e.w)},
$S:z+2}
A.aD_.prototype={
$2(d,e){var x=this.b.a.length
C.d.C(this.a.a,1/(x-1)*d)},
$S:972}
A.awy.prototype={
$1(d){return d},
$S:973}
A.bco.prototype={
$2(d,e){return d+e.b},
$S:z+15}
A.bcp.prototype={
$1(d){var x=this.a
return x.V(new A.bcn(x,d))},
$S:z+16}
A.bcn.prototype={
$0(){return this.a.d=this.b},
$S:0}
A.bcl.prototype={
$1(d){return new A.kN(d.a,d.b)},
$S:z+17}
A.bcm.prototype={
$2(d,e){return C.c.be(e.b,d.b)},
$S:z+18}
A.b2r.prototype={
$0(){return this.a.a.rr(D.P_)},
$S:0}
A.b2s.prototype={
$0(){return this.a.a.rr(D.t8)},
$S:0}
A.b2t.prototype={
$0(){return this.a.a.rr(D.P0)},
$S:0}
A.b_K.prototype={
$1(d){return d.b===0},
$S:z+19}
A.b_I.prototype={
$2(d,e){return Math.max(d,e.b)},
$S:z+20}
A.b_J.prototype={
$2(d,e){var x=null,w=C.c.B(d)
if(w<0||w>=this.a.length)return C.aM
return new B.bS(D.Wc,B.aa(this.a[w].a,x,x,x,D.ar6,x,x,x),x)},
$S:z+21}
A.bdI.prototype={
$1(d){var x=this,w=null,v=x.a,u=v.a.d,t=u===0?0:d.b/u,s=d.a
A:{if("Food"===s){u=B.aG(x.b,"cat_food",w)
break A}if("Travel"===s){u=B.aG(x.b,"cat_transport",w)
break A}if("Shop"===s){u=B.aG(x.b,"cat_shop",w)
break A}if("Bills"===s){u=B.aG(x.b,"cat_bills",w)
break A}if("Other"===s){u=B.aG(x.b,"cat_other",w)
break A}u=s
break A}return new A.B8(u,v.a.aVy(d.b),t,v.aw_(s),w)},
$S:z+22}
A.bdH.prototype={
$2(d,e){return d+e},
$S:164};(function aliases(){var x=A.Jv.prototype
x.anu=x.jr
x.ant=x.aUl
x=A.Sg.prototype
x.aq2=x.m
x=A.JC.prototype
x.a0n=x.jr
x=A.FD.prototype
x.aoK=x.ajx})();(function installTearOffs(){var x=a._static_2,w=a.installStaticTearOff,v=a._static_1,u=a._instance_1u,t=a._instance_2u
x(A,"bXI","bmV",23)
x(A,"bnf","bXv",24)
w(A,"bWp",3,null,["$3"],["bJJ"],25,0)
v(A,"bgp","c_g",26)
v(A,"bgo","bXy",27)
w(A,"bWs",3,null,["$3"],["bKv"],42,0)
w(A,"bWv",3,null,["$3"],["bQd"],29,0)
w(A,"bWr",3,null,["$3"],["bKu"],30,0)
w(A,"bWu",3,null,["$3"],["bQc"],31,0)
v(A,"bWq","bKt",32)
v(A,"bWt","bQb",33)
u(A.W5.prototype,"ga57","azZ",14)
t(A.U6.prototype,"gaBf","aBg",5)
w(A,"bYS",3,null,["$3"],["bL7"],34,0)
w(A,"bYR",3,null,["$3"],["bGk"],35,0)
v(A,"bYY","c_h",0)
w(A,"byP",4,function(){return{size:null}},["$5$size","$4"],["bx9",function(d,e,f,g){return A.bx9(d,e,f,g,null)}],36,0)
x(A,"bnH","c_f",37)
x(A,"bYT","bVZ",38)
x(A,"bYX","bXB",39)
x(A,"bYV","bXx",1)
x(A,"bYU","bXw",1)
v(A,"bYW","byq",41)
w(A,"bht",3,null,["$3"],["bYQ"],28,0)})();(function inheritance(){var x=a.mixin,w=a.mixinHard,v=a.inheritMany,u=a.inherit
v(B.A,[A.bt,A.afs,A.AL,A.anx,A.anw,A.afl,A.ai5,A.ai4,A.ai1,A.ai3,A.alB,A.aiE,A.apF,A.ai2,A.ahH,A.ai0,A.atp,A.JC,A.b5t,A.ats,A.afi,A.n6,A.ahY,A.ai6,A.ahZ,A.atU,A.O8,A.hu,A.ajp,A.ajs,A.afo,A.aft,A.afp,A.ai_,A.ajv,A.ajt,A.aoY,A.anv,A.aGr,A.ajr,A.vk,A.av1,A.ajB,A.ZS,A.aXb,A.lT,A.kN])
v(B.la,[A.bi7,A.bf5,A.bhN,A.atr,A.aTG,A.aTH,A.aTI,A.aTJ,A.aO2,A.aO3,A.aO4,A.aO6,A.aO7,A.aO9,A.aOa,A.aOb,A.aOc,A.aOd,A.aOe,A.b5A,A.b5B,A.aGq,A.bgR,A.bgQ,A.bgO,A.aGs,A.aGt,A.awy,A.bcp,A.bcl,A.b_K,A.bdI])
v(B.qg,[A.bf4,A.bf6,A.atq,A.b5x,A.aGx,A.aGy,A.aD_,A.bco,A.bcm,A.b_I,A.b_J,A.bdH])
u(A.Zj,A.afs)
u(A.afh,A.Zj)
u(A.Z3,A.afh)
v(B.Tq,[A.Cs,A.aAq,A.M8,A.BO])
u(A.w9,A.anx)
u(A.aaA,A.anw)
u(A.tC,A.afl)
u(A.DQ,A.ai5)
u(A.eP,A.ai4)
u(A.DP,A.ai1)
u(A.qG,A.ai3)
u(A.OM,A.alB)
u(A.mh,A.aiE)
u(A.mG,A.apF)
v(A.qG,[A.aiD,A.apE])
u(A.km,A.aiD)
u(A.kI,A.apE)
u(A.a2D,A.ai2)
v(A.a2D,[A.aiC,A.apD])
u(A.a3r,A.aiC)
u(A.acy,A.apD)
u(A.Lt,A.ahH)
u(A.uK,A.ai0)
u(A.LB,A.uK)
u(A.Jv,A.JC)
v(B.ah,[A.Z4,A.Au,A.abj,A.anT])
v(B.a5,[A.Qf,A.Wi,A.Tu,A.Bi,A.Sz,A.WD,A.B8])
v(B.a7,[A.W5,A.anU,A.ahS,A.ahT,A.afT,A.aoV,A.afR])
u(A.aaB,B.h5)
v(B.R,[A.afj,A.FD])
u(A.afk,A.afj)
u(A.Sg,A.afk)
u(A.Z5,A.Sg)
u(A.m8,A.afi)
u(A.a2B,A.ahY)
u(A.LI,A.ai6)
u(A.a2C,A.ahZ)
v(A.hu,[A.a2G,A.a2H,A.a2I,A.LD,A.LE,A.a2L,A.LG,A.LH,A.a2F,A.a2E,A.LC,A.a2J,A.a2K,A.LF])
v(B.tO,[A.aO5,A.aO8,A.b5y,A.b5z,A.aGv,A.aGw,A.bcn,A.b2r,A.b2s,A.b2t])
u(A.N1,B.Mq)
u(A.U6,B.xe)
u(A.ajq,A.Z3)
u(A.oX,A.ajq)
u(A.ea,A.ajp)
u(A.N2,A.ajs)
u(A.Ze,A.afo)
u(A.m9,A.aft)
u(A.Jz,A.afp)
u(A.ye,A.ai_)
u(A.aju,A.LI)
u(A.N3,A.aju)
u(A.a4Z,A.ajv)
u(A.ajn,A.eP)
u(A.oW,A.ajn)
u(A.pC,A.oW)
u(A.r2,A.ajt)
u(A.rU,A.aoY)
u(A.G5,A.anv)
u(A.N4,A.atU)
u(A.yS,B.aW)
u(A.yT,A.ajr)
u(A.aGu,A.Jv)
u(A.a4Y,B.Eu)
u(A.a9j,A.FD)
u(A.N8,A.ajB)
x(A.afh,A.bt)
x(A.afl,A.bt)
x(A.ahH,A.bt)
x(A.ai0,A.bt)
x(A.ai1,A.bt)
x(A.ai3,A.bt)
x(A.ai4,A.bt)
x(A.ai5,A.bt)
x(A.aiD,A.bt)
x(A.aiC,A.bt)
x(A.aiE,A.bt)
x(A.alB,A.bt)
x(A.anw,A.bt)
x(A.anx,A.bt)
x(A.apE,A.bt)
x(A.apD,A.bt)
x(A.apF,A.bt)
x(A.afi,A.bt)
w(A.afj,B.aE)
x(A.afk,B.e4)
w(A.Sg,B.a1B)
x(A.afs,A.bt)
x(A.ahY,A.bt)
x(A.ahZ,A.bt)
x(A.ai6,A.bt)
x(A.afo,A.bt)
x(A.afp,A.bt)
x(A.aft,A.bt)
x(A.ai_,A.bt)
x(A.ai2,A.bt)
x(A.ajn,A.bt)
x(A.ajp,A.bt)
x(A.ajq,A.bt)
x(A.ajs,A.bt)
x(A.ajt,A.bt)
x(A.aju,A.bt)
x(A.ajv,A.bt)
x(A.anv,A.bt)
x(A.aoY,A.bt)
x(A.ajr,A.bt)
x(A.ajB,A.bt)})()
B.Iu(b.typeUniverse,JSON.parse('{"eP":{"bt":[]},"qG":{"bt":[]},"mh":{"bt":[]},"mG":{"bt":[]},"km":{"bt":[]},"kI":{"bt":[]},"uK":{"bt":[]},"Z3":{"bt":[]},"w9":{"bt":[]},"aaA":{"bt":[]},"tC":{"bt":[]},"DQ":{"bt":[]},"DP":{"bt":[]},"OM":{"bt":[]},"a3r":{"bt":[]},"acy":{"bt":[]},"Lt":{"bt":[]},"LB":{"bt":[]},"Z4":{"ah":[],"i":[]},"Qf":{"a5":[],"i":[]},"W5":{"a7":["Qf"]},"m8":{"bt":[]},"aaB":{"h5":[],"aS":[],"i":[]},"Z5":{"e4":["R","h1"],"R":[],"aE":["R","h1"],"J":[],"aO":[],"aE.1":"h1","e4.1":"h1","aE.0":"R"},"Au":{"ah":[],"i":[]},"Zj":{"bt":[]},"a2B":{"bt":[]},"LI":{"bt":[]},"a2C":{"bt":[]},"a2G":{"hu":[]},"a2H":{"hu":[]},"a2I":{"hu":[]},"LD":{"hu":[]},"LE":{"hu":[]},"a2L":{"hu":[]},"LG":{"hu":[]},"LH":{"hu":[]},"a2F":{"hu":[]},"a2E":{"hu":[]},"LC":{"hu":[]},"a2J":{"hu":[]},"a2K":{"hu":[]},"LF":{"hu":[]},"FD":{"R":[],"J":[],"jy":[],"aO":[]},"N1":{"a5":[],"i":[]},"U6":{"a7":["N1"]},"oX":{"bt":[]},"ea":{"bt":[]},"m9":{"bt":[]},"oW":{"eP":[],"bt":[]},"pC":{"oW":[],"eP":[],"bt":[]},"r2":{"bt":[]},"rU":{"bt":[]},"G5":{"bt":[]},"yS":{"aW":["oX"],"aU":["oX"],"aU.T":"oX","aW.T":"oX"},"N2":{"bt":[]},"Ze":{"bt":[]},"Jz":{"bt":[]},"ye":{"bt":[]},"a2D":{"bt":[]},"N3":{"bt":[]},"a4Z":{"bt":[]},"yT":{"bt":[]},"a4Y":{"aS":[],"i":[]},"a9j":{"R":[],"J":[],"jy":[],"aO":[]},"N8":{"bt":[]},"Wi":{"a5":[],"i":[]},"Tu":{"a5":[],"i":[]},"Bi":{"a5":[],"i":[]},"Sz":{"a5":[],"i":[]},"WD":{"a5":[],"i":[]},"B8":{"a5":[],"i":[]},"abj":{"ah":[],"i":[]},"anT":{"ah":[],"i":[]},"anU":{"a7":["Wi"]},"ahS":{"a7":["Tu"]},"ahT":{"a7":["Bi"]},"afT":{"a7":["Sz"]},"aoV":{"a7":["WD"]},"afR":{"a7":["B8"]}}'))
B.bmN(b.typeUniverse,JSON.parse('{"Jv":1,"LI":1,"JC":1,"FD":1}'))
var y=(function rtii(){var x=B.ab
return{K:x("xc<C>"),f:x("l6"),V:x("m8"),J:x("m9"),k:x("aD"),C:x("ZS<N>"),I:x("xE"),v:x("hg"),c:x("hO"),_:x("qq"),E:x("bt"),D:x("eP"),L:x("h1"),m:x("dm<m,C>"),O:x("km"),B:x("mh"),N:x("r<@>"),A:x("E<bjR>"),U:x("E<eP>"),n:x("E<ea>"),H:x("E<vk>"),T:x("E<B<eP>>"),q:x("E<G5>"),u:x("E<rS>"),a:x("E<pC>"),p:x("E<i>"),x:x("E<N>"),t:x("E<m>"),F:x("bA<a7<a5>>"),b:x("oW"),g:x("ea"),e:x("oX"),Y:x("yT"),j:x("r2"),r:x("N8<ea>"),M:x("B<m>"),G:x("aF<@,@>"),w:x("j_"),R:x("O8<oX>"),l:x("nD"),X:x("nE"),Z:x("ca<@>"),o:x("j"),s:x("rS"),y:x("pC"),W:x("rU"),d:x("ff"),P:x("i4"),Q:x("kI"),bc:x("mG"),h:x("lT"),be:x("kN"),ad:x("k1<N>"),i:x("N"),z:x("@"),S:x("m"),aE:x("yS?")}})();(function constants(){var x=a.makeConstList
D.P6=new B.fY(1,1)
D.tg=new A.Cs(0,"left")
D.k5=new A.Cs(1,"top")
D.th=new A.Cs(2,"right")
D.cX=new A.Cs(3,"bottom")
D.alE=new A.w9(!1,A.bnf(),22,null)
D.nQ=new A.tC(16,null,D.alE,!0)
D.X6=new A.qG(C.o,null,2,null)
D.tl=new A.Jz(!1,D.X6,A.bYY(),!0)
D.Pp=new B.Cu(6,"dstIn")
D.Qp=new A.a2C()
D.Qq=new A.LD()
D.Qr=new A.LG()
D.azx=new A.aaA()
D.o5=new B.C(1,0.3764705882352941,0.49019607843137253,0.5450980392156862,C.f)
D.W0=new B.aB(0,0,0,20)
D.W2=new B.aB(0,10,0,10)
D.Wc=new B.aB(0,8,0,0)
D.Wh=new B.aB(15,15,15,15)
D.a9u=x([],B.ab("E<km>"))
D.a9v=x([],B.ab("E<kI>"))
D.WS=new A.Lt(D.a9u,D.a9v,!0)
D.vI=new A.aAq(0,"center")
D.azI=new A.ye(!0,A.bnH(),A.byP())
D.X4=new A.DP(!1,!0,null,A.bgo(),A.bgp(),!0,null,A.bgo(),A.bgp())
D.azJ=new A.DP(!0,!0,null,A.bgo(),A.bgp(),!0,null,A.bgo(),A.bgp())
D.Th=new B.C(1,0.9254901960784314,0.9372549019607843,0.9450980392156862,C.f)
D.SZ=new B.C(1,0.8117647058823529,0.8470588235294118,0.8627450980392157,C.f)
D.Tr=new B.C(1,0.6901960784313725,0.7450980392156863,0.7725490196078432,C.f)
D.Tl=new B.C(1,0.5647058823529412,0.6431372549019608,0.6823529411764706,C.f)
D.Sn=new B.C(1,0.47058823529411764,0.5647058823529412,0.611764705882353,C.f)
D.TO=new B.C(1,0.32941176470588235,0.43137254901960786,0.47843137254901963,C.f)
D.T8=new B.C(1,0.27058823529411763,0.35294117647058826,0.39215686274509803,C.f)
D.TS=new B.C(1,0.21568627450980393,0.2784313725490196,0.30980392156862746,C.f)
D.TL=new B.C(1,0.14901960784313725,0.19607843137254902,0.2196078431372549,C.f)
D.ahk=new B.dm([50,D.Th,100,D.SZ,200,D.Tr,300,D.Tl,400,D.Sn,500,D.o5,600,D.TO,700,D.T8,800,D.TS,900,D.TL],y.m)
D.d7=new B.r7(D.ahk,1,0.3764705882352941,0.49019607843137253,0.5450980392156862,C.f)
D.a1F=x([8,4],y.t)
D.X5=new A.qG(D.d7,null,0.4,D.a1F)
D.bN=new A.eP(0/0,0/0)
D.alG=new A.w9(!0,A.bnf(),44,null)
D.ti=new A.tC(16,null,D.alG,!0)
D.alF=new A.w9(!0,A.bnf(),30,null)
D.tj=new A.tC(16,null,D.alF,!0)
D.azK=new A.DQ(!0,D.ti,D.tj,D.ti,D.tj)
D.vX=new A.M8(0,"left")
D.Xn=new A.M8(1,"center")
D.vY=new A.M8(2,"right")
D.pB=new A.yT(0,0,0,0,!1)
D.Zr=new A.N2(0.5)
D.QQ=new A.a4Z()
D.Zs=new A.N3(D.QQ,A.bYX(),10,A.bYT(),!0,A.bYV(),A.bYU(),!0,null,null,null)
D.TY=new B.C(1,0.9019607843137255,0.49411764705882355,0.13333333333333333,C.f)
D.Ub=new B.C(1,0.20392156862745098,0.596078431372549,0.8588235294117647,C.f)
D.U7=new B.C(1,0.6078431372549019,0.34901960784313724,0.7137254901960784,C.f)
D.Tt=new B.C(1,0.9058823529411765,0.2980392156862745,0.23529411764705882,C.f)
D.SL=new B.C(1,0.10196078431372549,0.7372549019607844,0.611764705882353,C.f)
D.T4=new B.C(1,0.9450980392156862,0.7686274509803922,0.058823529411764705,C.f)
D.a0Y=x([D.TY,D.Ub,D.U7,D.Tt,D.SL,D.T4],B.ab("E<C>"))
D.azT=x([],B.ab("E<n6>"))
D.a9q=x([],B.ab("E<m9>"))
D.azU=x([],y.U)
D.azV=x([],y.n)
D.a9r=x([],y.q)
D.TX=new B.C(1,0.8784313725490196,0.9686274509803922,0.9803921568627451,C.f)
D.U1=new B.C(1,0.6980392156862745,0.9215686274509803,0.9490196078431372,C.f)
D.Su=new B.C(1,0.5019607843137255,0.8705882352941177,0.9176470588235294,C.f)
D.Td=new B.C(1,0.30196078431372547,0.8156862745098039,0.8823529411764706,C.f)
D.To=new B.C(1,0.14901960784313725,0.7764705882352941,0.8549019607843137,C.f)
D.Uj=new B.C(1,0,0.7372549019607844,0.8313725490196079,C.f)
D.S7=new B.C(1,0,0.6745098039215687,0.7568627450980392,C.f)
D.Tf=new B.C(1,0,0.592156862745098,0.6549019607843137,C.f)
D.Tp=new B.C(1,0,0.5137254901960784,0.5607843137254902,C.f)
D.TM=new B.C(1,0,0.3764705882352941,0.39215686274509803,C.f)
D.ahl=new B.dm([50,D.TX,100,D.U1,200,D.Su,300,D.Td,400,D.To,500,D.Uj,600,D.S7,700,D.Tf,800,D.Tp,900,D.TM],y.m)
D.ahs=new B.r7(D.ahl,1,0,0.7372549019607844,0.8313725490196079,C.f)
D.a9w=x([],B.ab("E<mh>"))
D.a9x=x([],B.ab("E<mG>"))
D.ajU=new A.OM(D.a9w,D.a9x)
D.ayW=new A.anT(null)
D.ayX=new A.Wi(null)
D.akE=new B.rD(!1,D.ayW,D.ayX,null,null,null,null,null)
D.alC=new B.rJ(C.y,C.i,0)
D.ap4=new B.H(!0,null,null,null,null,null,null,C.dl,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.aqc=new B.H(!0,C.o,null,null,null,null,14,C.Z,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.ar6=new B.H(!0,C.je,null,null,null,null,10,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null)
D.asK=new B.d8("Spending Over Time",null,F.n0,null,null,null,null,null,null,null)
D.P_=new A.BO(0,"weekly")
D.t8=new A.BO(1,"monthly")
D.P0=new A.BO(2,"yearly")})();(function staticFields(){$.brk=null})();(function lazyInitializers(){var x=a.lazyFinal,w=a.lazy
x($,"c0L","bio",()=>new A.atp())
w($,"c64","q_",()=>new A.aXb())})()};
(a=>{a["S+3FgfSXLb85ch3o+OFuVv6BNT4="]=a.current})($__dart_deferred_initializers__);