get_x(vec::Vector2D) = vec[1]
get_y(vec::Vector2D) = vec[2]

rotate_plus_90(vec::Vector2D) = typeof(vec)(-vec[2], vec[1])
rotate_minus_90(vec::Vector2D) = typeof(vec)(vec[2], -vec[1])
rotate_180(vec::Vector2D) = -vec

rotate(x::T, y::T, c::T, s::T) where {T} = Vector2D(c * x - s * y, s * x + c * y)
rotate(vec::Vector2D{T}, theta::T) where {T} = rotate(vec[1], vec[2], cos(theta), sin(theta))
rotate(vec::Vector2D{T}, dir::Vector2D{T}) where {T} = rotate(vec[1], vec[2], dir[1], dir[2])

get_relative_direction(dir1::Vector2D{T}, dir2::Vector2D{T}) where {T} = typeof(dir1)(dir2[1] * dir1[1] + dir2[2] * dir1[2], dir2[2] * dir1[1] - dir2[1] * dir1[2])
invert_relative_direction(dir::Vector2D) = typeof(dir)(dir[1], -dir[2])

function invert(pos::Vector2D{T}, dir::Vector2D{T}) where {T}
    inv_dir = invert_relative_direction(dir)
    inv_pos = -rotate(pos, inv_dir)
    return inv_pos, inv_dir
end
