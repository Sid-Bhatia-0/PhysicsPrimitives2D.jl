#####
# Vec
#####

get_x(vec::SA.SVector) = vec[1]
get_y(vec::SA.SVector) = vec[2]

rotate_plus_90(vec::SA.SVector{2}) = typeof(vec)(-vec[2], vec[1])
rotate_minus_90(vec::SA.SVector{2}) = typeof(vec)(vec[2], -vec[1])
rotate_180(vec::SA.SVector{2}) = -vec

rotate(x::T, y::T, c::T, s::T) where {T} = SA.SVector(c * x - s * y, s * x + c * y)
rotate(vec::SA.SVector{2, T}, theta::T) where {T} = rotate(vec[1], vec[2], cos(theta), sin(theta))

#####
# Axes
#####

struct Axes{T}
    x_cap::SA.SVector{2, T}
    y_cap::SA.SVector{2, T}
end

get_x_cap(axes::Axes) = axes.x_cap
get_y_cap(axes::Axes) = axes.y_cap

function Axes{T}() where {T}
    x_cap = SA.SVector(one(T), zero(T))
    y_cap = SA.SVector(zero(T), one(T))
    return Axes(x_cap, y_cap)
end

function Axes(angle::T) where {T}
    x_cap = SA.SVector(cos(angle), sin(angle))
    y_cap = rotate_plus_90(x_cap)
    return Axes(x_cap, y_cap)
end

rotate_plus_90(axes::Axes) = Axes(get_y_cap(axes), -get_x_cap(axes))
rotate_180(axes::Axes) = Axes(-get_x_cap(axes), -get_y_cap(axes))
rotate_minus_90(axes::Axes) = Axes(-get_y_cap(axes), get_x_cap(axes))

function rotate(vec::SA.SVector{2, T}, axes::Axes{T}) where {T}
    x_cap = get_x_cap(axes)
    c = x_cap[1]
    s = x_cap[2]
    return rotate(vec[1], vec[2], c, s)
end

#####
# relative orientation
#####

get_relative_direction(dir1::SA.SVector{2, T}, dir2::SA.SVector{2, T}) where {T} = typeof(dir1)(dir2[1] * dir1[1] + dir2[2] * dir1[2], dir2[2] * dir1[1] - dir2[1] * dir1[2])
invert_relative_direction(dir::SA.SVector{2}) = typeof(dir)(dir[1], -dir[2])

function get_relative_axes(axes1::Axes, axes2::Axes)
    x_cap_21 = get_relative_direction(get_x_cap(axes1), get_x_cap(axes2))
    y_cap_21 = rotate_plus_90(x_cap_21)
    return Axes(x_cap_21, y_cap_21)
end

function invert_relative_axes(axes::Axes)
    x_cap_inv = axes |> get_x_cap |> invert_relative_direction
    y_cap_inv = rotate_plus_90(x_cap_inv)
    return Axes(x_cap_inv, y_cap_inv)
end

function invert(pos::SA.SVector{2, T}, axes::Axes{T}) where {T}
    inv_axes = invert_relative_axes(axes)
    inv_pos = -rotate(pos, inv_axes)
    return inv_pos, inv_axes
end