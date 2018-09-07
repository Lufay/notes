# React

http://react-china.org/
http://www.runoob.com/react/react-tutorial.html
http://www.ruanyifeng.com/blog/2015/03/react.html

react + redux
前者UI 渲染，后者管理数据
es6，webpack
想提高性能，需要按需加载，immutable.js
生命周期、虚拟dom、组件化、jsx
react采用setState来控制视图的更新。setState会自动调用render函数，触发视图的重新渲染，如果仅仅只是state数据的变化而没有调用setState，并不会触发更新。 组件就是拥有独立功能的视图模块，许多小的组件组成一个大的组件，整个页面就是由一个个组件组合而成。它的好处是利于重复利用和维护。


用脚本进行DOM操作的代价很昂贵。有个贴切的比喻，把DOM和JavaScript各自想象为一个岛屿，它们之间用收费桥梁连接，js每次访问DOM，都要途径这座桥，并交纳“过桥费”,访问DOM的次数越多，费用也就越高。 因此，推荐的做法是尽量减少过桥的次数，努力待在ECMAScript岛上。因为这个原因react的虚拟dom就显得难能可贵了。
目前所有的框架都是走的数据决定视图的路线，react也是这样，Dom的状态由props和state的值决定，不过它创造了虚拟dom并且将它们储存起来，每当状态发生变化的时候就会创造新的虚拟节点和以前的进行对比，让变化的部分进行渲染。整个过程没有了获取、操作dom节点的步骤，只有一个渲染的过程，所以react就是一个ui框架。
