# 클래스의 두 property가 서로를 modify 하여 무한 루프에 빠지는 문제

## rect 클래스의 구조와 문제점

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
        fix_aspect_ratio (1,1) logical = 0
    end
    methods
        function obj = rect(width, height, fix_aspect_ratio)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
                fix_aspect_ratio (1,1) logical = 0
            end
            obj.width = width;
            obj.height = height;
            obj.fix_aspect_ratio = fix_aspect_ratio;
        end
        function set.width(obj, width)
            if obj.fix_aspect_ratio
                obj.height = obj.height * width/obj.width;
            end
            obj.width = width;
        end
        function set.height(obj, height)
            if obj.fix_aspect_ratio
                obj.width = obj.width * height/obj.height;
            end
            obj.height = height;
        end
    end
end
```

* fix_aspect_ratio가 1이면 width와 height의 비율을 유지하고 싶다.
* fix_aspect_ratio가 1일 때 width를 바꾸면 height도 바꿔야 하므로 set.height를 호출한다.
* set.height에서 width를 바꾸려고 set.width를 호출한다.
* 상호 무한 호출에 빠진다.

---

## 매트랩T님의 방법

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
        fix_aspect_ratio (1,1) logical = 0
    end

    methods
        function obj = rect(width, height, fix_aspect_ratio)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
                fix_aspect_ratio (1,1) logical = 0
            end
            obj.width = width;
            obj.height = height;
            obj.fix_aspect_ratio = fix_aspect_ratio;
        end
        
        function set.width(obj, width)
            if obj.fix_aspect_ratio
                obj.fix_aspect_ratio = false; % set temporary false
                obj.height = obj.height * width/obj.width;
                obj.fix_aspect_ratio = true; % retrieve as true
            end
            obj.width = width;
        end

        function set.height(obj, height)
            if obj.fix_aspect_ratio
                obj.fix_aspect_ratio = false; % set temporary false
                obj.width = obj.width * height/obj.height;
                obj.fix_aspect_ratio = true; % retrieve as true
            end
            obj.height = height;
        end
    end
end
```

* set.width 안에서 set.height를 호출하기 전에 fix_aspect_ratio를 잠시 false로 둔다.
* height를 바꾼 후 돌아와서 fix_aspect_ratio = true로 세팅한다.
* set.height에서도 같은 방법으로 동작시킨다.


---

## 시뮬시뮬님의 방법

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
        fix_aspect_ratio (1,1) logical = 0
    end

    methods
        function obj = rect(width, height, fix_aspect_ratio)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
                fix_aspect_ratio (1,1) logical = 0
            end
            obj.width = width;
            obj.height = height;
            obj.fix_aspect_ratio = fix_aspect_ratio;
        end
        
        function set.width(obj, width)
            persistent num_calls
            if isempty(num_calls)
                num_calls = 1
            else
                return
            end
            
            if obj.fix_aspect_ratio
                obj.height = obj.height * width/obj.width;
            end
            obj.width = width;
            clear num_calls
        end

        function set.height(obj, height)
            persistent num_calls
            if isempty(num_calls)
                num_calls = 1
            else
                return
            end

            if obj.fix_aspect_ratio
                obj.width = obj.width * height/obj.height;
            end
            obj.height = height;
            clear num_calls
        end
    end
end
```

* set 함수 내에, 첫 번째 호출인지 확인하기 위한 persistent 변수를 만든다.
* 첫 번째 호출이 아니면 되돌려버린다.

---

## 게으른맽랩의 방법

```matlab
classdef rect < handle
    properties (Dependent)
        width
        height
        area
    end
    properties
        fix_aspect_ratio (1,1) logical = 0
    end
    properties (Access = private)
        p_width
        p_height
    end

    methods
        function obj = rect(width, height, fix_aspect_ratio)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
                fix_aspect_ratio (1,1) logical = 0
            end
            obj.p_width = width;
            obj.p_height = height;
            obj.fix_aspect_ratio = fix_aspect_ratio;
        end
        
        function width = get.width(obj)
            width = obj.p_width;
        end

        function height = get.height(obj)
            height = obj.p_height;
        end

        function set.width(obj, width)
            if obj.fix_aspect_ratio
                obj.p_height = obj.p_height * width/obj.p_width;
            end
            obj.p_width = width;
        end
        function set.height(obj, height)
            if obj.fix_aspect_ratio
                obj.p_width = obj.p_width * height/obj.p_height;
            end
            obj.p_height = height;
        end

        function area = get.area(obj)
            area = obj.width*obj.height;
        end

        function obj = make_unit_square(obj)
            obj.fix_aspect_ratio = 0;
            obj.width = 1;
            obj.height = 1;
        end

    end
end
```

* Private property인 p_width와 p_height를 만든다.
* Dependent property인 width와 height를 만든다.
* set.width와 set.height에서는 서로의 set를 호출하지 않고 private property를 직접 변경한다.
