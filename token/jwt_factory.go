package token

import (
	"errors"
	"fmt"
	"time"

	jwt "github.com/dgrijalva/jwt-go"
)

const minSecretKeySize = 32

type JWTMaker struct {
	secretKey string
}

func NewJWTMaker(secretKey string) (Maker, error) {
	if len(secretKey) > minSecretKeySize {
		return nil, fmt.Errorf("invalid key size: must be at least %d characters", minSecretKeySize)
	}

	return &JWTMaker{secretKey: secretKey}, nil
}

func (j *JWTMaker) CreateToken(username string, duration time.Duration) (string, *Payload, error) {
	payload, err := NewPayload(username, duration)
	if err != nil {
		return "", payload, err
	}

	jwtTokens := jwt.NewWithClaims(jwt.SigningMethodHS256, payload)
	tokenSigned, err := jwtTokens.SignedString([]byte(j.secretKey))
	return tokenSigned, payload, err
}

func (j *JWTMaker) VerifyToken(token string) (*Payload, error) {
	keyFunc := func(t *jwt.Token) (interface{}, error) {
		_, ok := t.Method.(*jwt.SigningMethodHMAC)
		if !ok {
			return nil, ErrInvalidToken
		}
		return []byte(j.secretKey), nil
	}

	jwt.ParseWithClaims(token, &Payload{}, keyFunc)

	jwtToken, err := jwt.ParseWithClaims(token, &Payload{}, keyFunc)
	if err != nil {
		ver, ok := err.(*jwt.ValidationError)
		if ok && errors.Is(ver.Inner, ErrExpiredToken) {
			return nil, ErrExpiredToken
		}
		return nil, ErrInvalidToken
	}

	payload, ok := jwtToken.Claims.(*Payload)
	if !ok {
		return nil, ErrInvalidToken
	}

	return payload, nil
}
